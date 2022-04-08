function prop () {
  const bars = document.querySelectorAll(".category-bar");
  const props = document.querySelectorAll(".percentage");
  for(let i = 0; i < props.length; i++){
    if(bars[i].getAttribute("style") != `width:${props[i].innerHTML}%;`) {
      bars[i].setAttribute("style", `width:${props[i].innerHTML}%;`)
    };
  };
};

window.addEventListener("turbolinks:load", prop);