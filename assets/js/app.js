/* 蜂蜜罐小熊 · 交互脚本 */
(() => {
  'use strict';

  const mv = document.getElementById('mv');
  const reduce = window.matchMedia('(prefers-reduced-motion: reduce)').matches;

  /* ── 查看器工具条 ─────────────────────────────────────────── */
  document.querySelectorAll('.tool').forEach((btn) => {
    btn.addEventListener('click', async () => {
      const action = btn.dataset.action;
      if (!mv) return;
      if (action === 'rotate') {
        mv.autoRotate = !mv.autoRotate;
        btn.setAttribute('aria-pressed', String(mv.autoRotate));
      } else if (action === 'reset') {
        mv.cameraOrbit = '-16deg 76deg 105%';
        mv.fieldOfView = 'auto';
        mv.jumpCameraToGoal?.();
      } else if (action === 'fullscreen') {
        try {
          if (document.fullscreenElement) await document.exitFullscreen();
          else await mv.requestFullscreen();
        } catch (_) { /* 浏览器不支持则忽略 */ }
      } else if (action === 'ar') {
        if (mv.canActivateAR) mv.activateAR();
        else btn.title = '当前设备不支持 AR';
      }
    });
  });

  if (mv) {
    if (reduce) {
      mv.removeAttribute('auto-rotate');
      const r = document.querySelector('[data-action="rotate"]');
      if (r) r.setAttribute('aria-pressed', 'false');
    }
    // 模型加载完成后淡入
    mv.addEventListener('load', () => {
      mv.classList.add('is-loaded');
      const poster = mv.shadowRoot?.querySelector('.slot.poster');
      if (poster) poster.style.transition = 'opacity .6s ease';
    });
  }

  /* ── 缩略图高亮 ───────────────────────────────────────────── */
  document.querySelectorAll('.thumbs figure').forEach((fig) => {
    fig.addEventListener('click', () => {
      document.querySelectorAll('.thumbs figure').forEach((f) => f.classList.remove('is-active'));
      fig.classList.add('is-active');
    });
  });

  /* ── 灯箱 ─────────────────────────────────────────────────── */
  const lb = document.getElementById('lightbox');
  const lbImg = lb?.querySelector('img');
  let lastFocus = null;

  const openLb = (src, alt) => {
    if (!lb || !lbImg) return;
    lastFocus = document.activeElement;
    lbImg.src = src;
    lbImg.alt = alt || '';
    lb.hidden = false;
    document.body.style.overflow = 'hidden';
    lb.querySelector('.lb-close')?.focus();
  };
  const closeLb = () => {
    if (!lb) return;
    lb.hidden = true;
    lbImg.removeAttribute('src');
    document.body.style.overflow = '';
    lastFocus?.focus?.();
  };

  document.querySelectorAll('[data-zoom]').forEach((el) => {
    el.addEventListener('click', () => {
      const img = el.querySelector('img');
      openLb(el.dataset.zoom, img?.alt);
    });
  });
  lb?.addEventListener('click', (e) => {
    if (e.target === lb || e.target.classList.contains('lb-close')) closeLb();
  });
  window.addEventListener('keydown', (e) => {
    if (e.key === 'Escape' && lb && !lb.hidden) closeLb();
  });

  /* ── 滚动淡入 ─────────────────────────────────────────────── */
  if (!reduce && 'IntersectionObserver' in window) {
    const targets = document.querySelectorAll('.section-head, .spec-card, .steps li, .fig, .sw-item, .dl-card');
    targets.forEach((t) => t.classList.add('reveal'));
    const io = new IntersectionObserver((entries) => {
      entries.forEach((entry) => {
        if (entry.isIntersecting) {
          entry.target.classList.add('in');
          io.unobserve(entry.target);
        }
      });
    }, { rootMargin: '0px 0px -8% 0px', threshold: 0.08 });
    targets.forEach((t) => io.observe(t));
  }

  /* ── 年份 / 仓库链接 ──────────────────────────────────────── */
  const y = document.getElementById('year');
  if (y) y.textContent = String(new Date().getFullYear());

  const repo = document.getElementById('repo-link');
  if (repo && repo.getAttribute('href') === 'https://github.com/') {
    // 部署后把这里改成真实仓库地址即可
    repo.href = '#download';
    repo.removeAttribute('target');
  }
})();
