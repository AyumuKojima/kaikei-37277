function month () {
  const categoryMarks = document.querySelectorAll(".category-mark");
  const colorIds = document.querySelectorAll(".color-id");
  const colors = document.querySelectorAll(".color");
  const categoryNames = document.querySelectorAll(".category-name");
  var categoryIds = [];
  if (categoryIds.length == 0) {
    for (let i=0; i < categoryMarks.length; i++) {
      categoryIds.push(Number(categoryMarks[i].innerHTML)-1);
      const rgb = colors[colorIds[categoryIds[i]].innerHTML].innerHTML;
      categoryMarks[i].setAttribute("style", `color: rgb${rgb};`);
      categoryMarks[i].innerHTML = categoryNames[categoryIds[i]].innerHTML;
    };
  };

  
};

window.addEventListener('turbolinks:load', month);