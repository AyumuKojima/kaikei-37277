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

  const showInfos = document.querySelectorAll(".show-info");
  const spendShowBtns = document.getElementById("spend-show-btns");
  const yearForm = document.getElementById("_day_1i");
  const monthForm = document.getElementById("_day_2i");
  const dayForm = document.getElementById("_day_3i");
  const showDates = document.querySelectorAll(".show-date");
  const showSpends = document.querySelectorAll(".show-spend");
  const moneyForm = document.getElementById("money");
  const categoryForm = document.getElementById("category_id");
  const memoForm = document.getElementById("memo");
  const showMemos = document.querySelectorAll(".show-memo");
  for (let i=0; i < showInfos.length; i++) {
    showInfos[i].addEventListener("click", () => {
      spendShowBtns.setAttribute("style", "display: block;");
      const date = new Date(showDates[i].innerHTML);
      yearForm.value = date.getFullYear();
      monthForm.value = date.getMonth()+1;
      dayForm.value = date.getDate();
      moneyForm.value = parseInt(showSpends[i].innerHTML, 10);
      categoryForm.value = categoryIds[i]+1;
      memoForm.value = showMemos[i].innerHTML.trim();
    });
  };

};

window.addEventListener('turbolinks:load', month);