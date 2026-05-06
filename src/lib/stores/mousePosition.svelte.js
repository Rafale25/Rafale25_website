export function mousePosition(init = { x: 0, y: 0 }) {
  let pos = $state(init);

  $effect(() => {
    const update = (e) => pos = { x: e.clientX, y: e.clientY };
    window.addEventListener('mousemove', update);
    return () => window.removeEventListener('mousemove', update);
  });

  return {
    get x() { return pos.x; },
    get y() { return pos.y; }
  };
}
