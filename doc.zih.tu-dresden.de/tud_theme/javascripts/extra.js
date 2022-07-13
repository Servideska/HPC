// keyboard navigation
// allow to expand navigation items with nested items by
let nav_links = document.querySelectorAll('.md-nav__link');

Array.from(nav_links).forEach(label => {
    label.addEventListener('keydown', e => {
      if (e.key === 'Enter' || e.key === ' ' || e.key === 'ArrowLeft'|| e.key === 'ArrowRight') {
        e.preventDefault();
        label.click();
      };
    });
  });