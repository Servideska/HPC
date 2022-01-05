// keyboard navigation
// allow to expand navigation items with nested items by specified keys
let nav_links = document.querySelectorAll('.md-nav__link');

Array.from(nav_links).forEach(label => {
    label.addEventListener('keydown', e => {
      // 13 === Enter
      // 32 === Spacebar
      // 37 === ArrowLeft
      // 39 === ArrowRight
      if (e.keyCode === 13 || e.keyCode === 32 || e.keyCode ===37 || e.keyCode === 39) {
        e.preventDefault();
        label.click();
      };
    });
  });