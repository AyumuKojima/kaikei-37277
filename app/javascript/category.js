function categoryColor () {
  const colors = document.querySelectorAll(".color");
  const thinColors = document.querySelectorAll(".thin-color");
  const colorIds = document.querySelectorAll(".color-id");
  const categoryBox = document.querySelectorAll(".category-box");
  const categoryBoxHeader = document.querySelectorAll(".category-box-header");
  const categoryShow = document.querySelectorAll(".category-show");
  const categoryDelete= document.querySelectorAll(".category-delete");
  const categoryBoxFooter = document.querySelectorAll(".category-box-footer");
  const categoryBar = document.querySelectorAll(".category-bar");
  const props = document.querySelectorAll(".percentage");
  const categoryMoneySum = document.querySelectorAll(".category-money-sum");
  const percentageValues = document.querySelectorAll(".percentage-values");

  for(let i = 0; i < categoryBox.length; i++){
    const id = colorIds[i].innerHTML
    const rgb = colors[id].innerHTML;
    const rgba = thinColors[id].innerHTML;
    categoryBox[i].setAttribute("style", `border-color: rgb${rgb};`);
    categoryBoxHeader[i].setAttribute("style", `color: rgb${rgb};`);
    categoryShow[i].setAttribute("style",`background-color: rgb${rgb};`);
    categoryDelete[i].setAttribute("style", `background-color: rgb${rgb};`);
    categoryBoxFooter[i].setAttribute("style", `border-color: rgb${rgb};`);
    categoryBar[i].setAttribute("style", `background-color: rgba${rgba}; width: ${props[i].innerHTML}%;`);
    categoryMoneySum[i].setAttribute("style", `color: rgb${rgb};`);
    percentageValues[i].setAttribute("style", `color: rgb${rgb};`);
  };
};

window.addEventListener('turbolinks:load', categoryColor);