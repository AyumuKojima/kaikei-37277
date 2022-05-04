function month () {
  const categoryMarks = document.querySelectorAll(".category-mark");
  const submitBtn = document.getElementById("spend-update-submit");
  const spendDeleteBtn = document.getElementById("spend-delete-btn");
  const categoryIds = document.querySelectorAll(".select-category-id");
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
  const updateIdForm = document.getElementById("update_id");
  const indexForm = document.getElementById("index")
  const spendIds = document.querySelectorAll(".show-id");

  for (let i=0; i < categoryMarks.length; i++) {
    setCategoryName(categoryMarks[i]);
  };

  fillInForm(categoryIds, showInfos, spendShowBtns, yearForm, monthForm, dayForm, showDates, showSpends, moneyForm, categoryForm, memoForm, showMemos, indexForm, spendIds, updateIdForm);

  submitBtn.addEventListener('click', (e) => {
    window.pendingRequestCount = 1;
    e.preventDefault();
    adjustToken();
    const form = document.getElementById("form");
    const formData = new FormData(form);
    XHR = setUpdateXHR(yearForm, monthForm, updateIdForm);
    XHR.send(formData);

    XHR.onload = () => {
      window.pendingRequestCount = 0;
      if (XHR.status != 200) {
        alert(`Error ${XHR.status}: ${XHR.statusText}`);
        return null;
      } else if (XHR.response.error) {
        setErrorMessages(XHR.response.error_messages);
      } else {
        const oldSpendDay = XHR.response.old_spend_day;
        const currentYear = document.getElementById("display-year").innerHTML;
        const currentMonth = document.getElementById("display-month").innerHTML;
        if (currentYear == yearForm.value && currentMonth == monthForm.value && oldSpendDay == dayForm.value) {
          const item = XHR.response.spend;
          const index = XHR.response.index;
          setSum(XHR.response.sum);
          updateSpendView(item, XHR.response.category_index, categoryMarks[index], showSpends[index], showMemos[index], categoryIds[index]);
          clearForm(moneyForm, categoryForm, memoForm, updateIdForm, indexForm, yearForm, monthForm, dayForm, spendShowBtns);
          if (document.getElementById("category-sum") != null){
            if (XHR.response.past_category_id != item.category_id) {
              showInfos[index].setAttribute("style", "display: none;");
            };
            setCategoryInfo(XHR);
          };
        } else {
          location.reload();
        };
      };
    };
  });

  spendDeleteBtn.addEventListener('click', () => {
    window.pendingRequestCount = 1;
    adjustToken();
    const form = document.getElementById("form");
    const formData = new FormData(form);
    XHR = setDeleteXHR(yearForm, monthForm, updateIdForm);
    XHR.send(formData);
    XHR.onload = () => {
      window.pendingRequestCount = 0;
      if (XHR.status != 200) {
        alert(`Error ${XHR.status}: ${XHR.statusText}`);
        return null;
      };
      const index = XHR.response.index;
      showInfos[index].setAttribute("style", "display: none;");
      clearForm(moneyForm, categoryForm, memoForm, updateIdForm, indexForm, yearForm, monthForm, dayForm, spendShowBtns);
      setSum(XHR.response.sum);
      if (document.getElementById("category-sum") != null){
        setCategoryInfo(XHR);
      };
    };
  });
};

function setCategoryName (categoryMark) {
  const categoryIndex = Number(categoryMark.innerHTML);
  const colorIds = document.querySelectorAll(".color-index");
  const colors = document.querySelectorAll(".color");
  const categoryTitles = document.querySelectorAll(".category-name");
  const rgb = colors[colorIds[categoryIndex].innerHTML].innerHTML;
  categoryMark.setAttribute("style", `color: rgb${rgb};`);
  categoryMark.innerHTML = categoryTitles[categoryIndex].innerHTML;
};

function fillInForm (categoryIds, showInfos, spendShowBtns, yearForm, monthForm, dayForm, showDates, showSpends, moneyForm, categoryForm, memoForm, showMemos, indexForm, spendIds, updateIdForm) {
  for (let i=0; i < showInfos.length; i++) {
    showInfos[i].addEventListener("click", () => {
      if (document.getElementById("spend-form").getAttribute("style") == "display: none;") {
        document.getElementById("spend-form").setAttribute("style", "display: block;");
        document.getElementById("edit-category-contents").setAttribute("style", "display: none;");
      };
      setBorder(showInfos, showInfos[i]);
      spendShowBtns.setAttribute("style", "display: block;");
      const date = new Date(showDates[i].innerHTML);
      yearForm.value = date.getFullYear();
      monthForm.value = date.getMonth()+1;
      dayForm.value = date.getDate();
      moneyForm.value = parseInt(showSpends[i].innerHTML, 10);
      categoryForm.value = categoryIds[i].innerHTML;
      memoForm.value = showMemos[i].innerHTML.trim();
      updateIdForm.value = spendIds[i].innerHTML.trim();
      indexForm.value = i;
    });
  };
};

function setBorder (showInfos, showInfo) {
  const borderStyle = "border:3px solid deeppink;"
  for (let k=0; k < showInfos.length; k++) {
    if (showInfos[k].getAttribute("style") == borderStyle) {
      showInfos[k].removeAttribute("style")
    };
  };
  showInfo.setAttribute("style", borderStyle);
};

function adjustToken () {
  const TokenInputForms = document.querySelectorAll('input[name="authenticity_token"]');
  for (let i=0; i < TokenInputForms.length; i++) {
    TokenInputForms[i].value = document.querySelector('meta[name="csrf-token"]').getAttribute('content');
  };
};

function setUpdateXHR (year, month, updateId) {
  const XHR = new XMLHttpRequest();
  XHR.open('PATCH', `/years/${year.value}/months/${month.value}/spends/${updateId.value}`, true);
  XHR.responseType = "json";
  return XHR;
};

function setDeleteXHR (year, month, deleteId) {
  const XHR = new XMLHttpRequest();
  XHR.open('DELETE', `/years/${year.value}/months/${month.value}/spends/${deleteId.value}`, true);
  XHR.responseType = "json";
  return XHR;
}

function setSum (sum) {
  const monthSum = document.getElementById("month-sum");
  monthSum.innerHTML = sum.toLocaleString();
};

function updateSpendView (item, category_index, categoryMark, showSpend, showMemo, categoryId) {
  categoryMark.innerHTML = category_index;
  setCategoryName(categoryMark);
  showSpend.innerHTML = `${item.money}円`;
  showMemo.innerHTML = item.memo;
  categoryId.innerHTML = item.category_id;
};

function clearForm (moneyForm, categoryForm, memoForm, updateIdForm, indexForm, yearForm, monthForm, dayForm, btns) {
  moneyForm.value = "";
  categoryForm.value = 0;
  memoForm.value = "";
  updateIdForm.value = "";
  indexForm.value = "";
  const today = new Date();
  yearForm.value = today.getFullYear();
  monthForm.value = today.getMonth()+1;
  dayForm.value = today.getDate();
  btns.setAttribute('style', "display: none;");
};

function setCategoryInfo (XHR) {
  const categorySum = document.getElementById("category-sum");
  const categoryBar = document.getElementById("category-bar");
  const thinColors = document.querySelectorAll(".thin-color");
  const colorId = document.getElementById("color-id");
  const id = colorId.innerHTML;
  const rgba = thinColors[id].innerHTML;
  categorySum.innerHTML = `${XHR.response.category_sum}円`
  categoryBar.setAttribute("style", `background-color: rgba${rgba}; width: ${XHR.response.prop}%;`);
};

function setErrorMessages (errorMessages) {
  err = document.getElementById("spend-error-messages");
  for (let i=0; i<errorMessages.length; i++) {
    err.insertAdjacentHTML('beforeend', `<li>${errorMessages[i]}</li>`)
  };
};

window.addEventListener('turbolinks:load', month);