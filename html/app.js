const root = document.getElementById('logo-root');
const logo3d = document.getElementById('logo-3d');
const logoImgs = document.querySelectorAll('.logo-img');
const modeClasses = ['mode-static', 'mode-rotatory', 'mode-breathing', 'mode-floating', 'mode-shimmer', 'mode-shimmer-rotatory'];
const anchorClasses = ['anchor-top-left', 'anchor-top-center', 'anchor-top-right', 'anchor-bottom-left', 'anchor-bottom-right'];
let readySent = false;

let shimmerStyle = null;
let lastConfig = null;

let hideReasons = new Set();
let transitionDuration = 350;

const injectShimmerMask = path => {
  if (shimmerStyle) shimmerStyle.remove();
  shimmerStyle = document.createElement('style');
  shimmerStyle.textContent = `
    #logo-root.mode-shimmer #logo-3d::after,
    #logo-root.mode-shimmer-rotatory #logo-3d::after {
      -webkit-mask-image: url("${path}");
      mask-image: url("${path}");
      -webkit-mask-size: contain;
      mask-size: contain;
      -webkit-mask-repeat: no-repeat;
      mask-repeat: no-repeat;
      -webkit-mask-position: center;
      mask-position: center;
    }
  `;
  document.head.appendChild(shimmerStyle);
};

const sendReady = () => {
  if (readySent) return;
  readySent = true;
  fetch(`https://${GetParentResourceName()}/logo:ready`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ ready: true })
  }).catch(() => {});
};

const resolveOffset = (val, viewportDim) => {
  if (val == null) return Math.round(viewportDim * 0.01);
  const str = String(val);
  const num = parseFloat(str);
  if (str.includes('vw')) return Math.round(viewportDim * num / 100);
  if (str.includes('vh')) return Math.round(viewportDim * num / 100);
  if (str.includes('%')) return Math.round(viewportDim * num / 100);
  return Math.round(num);
};

const applyAnchor = (anchor, x, y) => {
  anchorClasses.forEach(cls => root.classList.remove(cls));
  const anchorKey = typeof anchor === 'string' ? anchor : 'top-left';
  const target = anchorClasses.find(cls => cls.endsWith(anchorKey)) || 'anchor-top-left';
  root.classList.add(target);
  const offsetX = resolveOffset(x, window.innerWidth);
  const offsetY = resolveOffset(y, window.innerHeight);
  root.style.setProperty('--logo-offset-x', `${offsetX}px`);
  root.style.setProperty('--logo-offset-y', `${offsetY}px`);
};

const applySize = size => {
  const baseW = Number(size?.width) || 130;
  const baseH = Number(size?.height) || 112;
  const scale = window.innerHeight / 1080;
  const w = Math.round(baseW * scale);
  const h = Math.round(baseH * scale);
  logo3d.style.width = `${w}px`;
  logo3d.style.height = `${h}px`;
  logoImgs.forEach(img => {
    img.style.width = '100%';
    img.style.height = '100%';
  });
};

window.addEventListener('resize', () => {
  if (!lastConfig) return;
  applyAnchor(lastConfig.position?.anchor, lastConfig.position?.x, lastConfig.position?.y);
  applySize(lastConfig.size);
});

const applyAnimation = anim => {
  modeClasses.forEach(cls => root.classList.remove(cls));
  if (!anim || !anim.mode) return;
  const mode = anim.mode;
  const targetClass = modeClasses.find(cls => cls.endsWith(mode));
  if (!targetClass) return;
  root.classList.add(targetClass);
  const speed = Number(anim.speed) > 0 ? Number(anim.speed) : 1;
  root.style.setProperty('--anim-speed', speed);
  const intensity = Number(anim.intensity) > 0 ? Number(anim.intensity) : 1;
  root.style.setProperty('--anim-intensity', intensity);
  root.style.setProperty('--anim-breathe-scale', 1 + 0.06 * intensity);
  root.style.setProperty('--anim-breathe-lift', `${-(2 + 1 * intensity)}px`);
  root.style.setProperty('--anim-breathe-brightness', Math.min(1 + 0.3 * intensity, 1.8));
  root.style.setProperty('--anim-float-distance', `${-(4 + 2 * intensity)}px`);
  const shimmerAlpha = Math.min(0.35 * intensity, 0.7);
  root.style.setProperty('--anim-shimmer-alpha', shimmerAlpha);
  root.style.setProperty('--anim-shimmer-alpha-mid', Math.min(shimmerAlpha + 0.25, 0.9));
};

const hideInternal = reason => {
  hideReasons.add(reason);
  root.classList.add('watermark-hidden');
};

const showInternal = reason => {
  hideReasons.delete(reason);
  if (hideReasons.size === 0) {
    root.classList.remove('watermark-hidden');
  }
};

const updateTransitionDuration = ms => {
  transitionDuration = ms;
  root.style.setProperty('--wm-transition-duration', `${ms}ms`);
};

const applyConfig = cfg => {
  lastConfig = cfg;
  const enabled = cfg.enabled !== false;
  root.style.display = enabled ? 'block' : 'none';
  applyAnchor(cfg.position?.anchor, cfg.position?.x, cfg.position?.y);
  applySize(cfg.size);
  const rawOpacity = Number(cfg.opacity);
  const opacity = Number.isFinite(rawOpacity) ? Math.min(Math.max(rawOpacity, 0), 1) : 1;
  root.style.opacity = opacity;
  applyAnimation(cfg.animation);
  if (cfg.logoPath) {
    logoImgs.forEach(img => { img.src = cfg.logoPath; });
    injectShimmerMask(cfg.logoPath);
  }

  if (cfg.autoHide && cfg.autoHide.transitionDuration) {
    updateTransitionDuration(cfg.autoHide.transitionDuration);
  }
};

window.addEventListener('message', event => {
  const data = event.data || {};
  if (data.action === 'applyConfig') {
    applyConfig(data.payload || {});
  } else if (data.action === 'hide') {
    hideInternal('manual');
  } else if (data.action === 'show') {
    showInternal('manual');
  }
});

window.addEventListener('DOMContentLoaded', sendReady);
