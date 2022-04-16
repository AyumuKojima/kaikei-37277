window.addEventListener("turbolinks:load", calendar);

function calendar () {
  const displayYear = document.getElementById("display-year").innerHTML;
  const displayMonth = document.getElementById("display-month").innerHTML;
  const dates = document.querySelectorAll(".date");
  const wDayNum = document.getElementById("wday_num").innerHTML;
  setDateNumber(displayYear, displayMonth, dates, wDayNum);

  const eachSums = document.querySelectorAll(".each-sum");
  const daySums = document.querySelectorAll(".day-sum");
  setEachSums(eachSums, daySums);

  const bottom = document.getElementById("bottom");
  const bottomLeft = document.getElementById("bottom-left");
  const rows = document.querySelectorAll(".row");
  removeBottomRow(bottom, bottomLeft, rows);
  
  const thisMonths = document.querySelectorAll(".this-month");
  setTodayColor(displayYear, displayMonth, thisMonths);

  const yearForm = document.getElementById("_day_1i");
  const monthForm = document.getElementById("_day_2i");
  const dayForm = document.getElementById("_day_3i");
  const thisMonthDates = document.querySelectorAll(".this-month-date");
  const lastMonths = document.querySelectorAll(".last-month");
  const lastMonthDates = document.querySelectorAll(".last-month-date");
  const nextMonths = document.querySelectorAll(".next-month");
  const nextMonthDates = document.querySelectorAll(".next-month-date");

  for (let j=0; j < lastMonths.length; j++) {
    lastMonths[j].addEventListener('click', () => {
      if (displayMonth == 1) {
        yearForm.value = Number(displayYear) - 1;
        monthForm.value = 12;
      } else {
        yearForm.value = displayYear;
        monthForm.value = Number(displayMonth) - 1;
      };
      dayForm.value = lastMonthDates[j].innerHTML;
    });
  };

  for (let i=0; i < thisMonths.length; i++) {
    thisMonths[i].addEventListener('click', () => {
      yearForm.value = displayYear;
      monthForm.value = displayMonth;
      dayForm.value = thisMonthDates[i].innerHTML;
    });
  };

  for (let n=0; n < nextMonths.length; n++) {
    nextMonths[n].addEventListener('click', () => {
      if (displayMonth == 12) {
        yearForm.value = Number(displayYear) + 1;
        monthForm.value = 1;
      } else {
        yearForm.value = displayYear;
        monthForm.value = Number(displayMonth) + 1;
      };
      dayForm.value = nextMonthDates[n].innerHTML;
    });
  };



};


function getDayNum (year, month) {
  return new Date(year, month, 0).getDate();
};

function getLastDayNum (year, month) {
  if (month == 1) {
    return getDayNum(Number(year)-1, 12);
  } else {
    return getDayNum(year, Number(month)-1);
  };
};

function setDateNumber (year, month, dates, wDayNum) {
  let k = 1;
  let flag = 1;
  if (wDayNum == 0) {
    flag = 2;
  } else {
    k = getLastDayNum(year, month) - Number(wDayNum) + 1;
  };
  let w = 0
  for(let i=0; i < dates.length; i++) {
    if (flag == 1) {
      dates[i].setAttribute("class", "date last-month");
      dates[i].insertAdjacentHTML('afterbegin', `<div class='date-num last-month-date'>${k}</div><div class='last-month-sum'></div>`);
      k += 1;
      w += 1;
      dates[i].setAttribute("style", "background-color: lightgrey;");
      if (k > getLastDayNum(year, month)) {
        k = 1;
        flag = 2;
      };
    } else if (flag == 2) {
      if (w == 0) {
        dates[i].setAttribute("class", "date this-month sunday");
        w += 1;
      } else if (w == 6) {
        dates[i].setAttribute("class", "date this-month saturday");
        w = 0;
      } else {
        dates[i].setAttribute("class", "date this-month");
        w += 1;
      };
      dates[i].insertAdjacentHTML('afterbegin', `<div class='date-num this-month-date'>${k}</div><div class='day-sum'></div>`);
      k += 1;
      if (k > getDayNum(year, month)) {
        k = 1;
        flag = 3;
      };
    } else {
      dates[i].setAttribute("class", "date next-month")
      dates[i].insertAdjacentHTML('afterbegin', `<div class='date-num next-month-date'>${k}</div><div class='next-month-sum'></div>`);
      k += 1;
      dates[i].setAttribute("style", "background-color: lightgrey;");
    };
  };
};

function setEachSums (eachSums, daySums) {
  for (let i=0; i < eachSums.length; i++) {
    if (eachSums[i].innerHTML != 0) {
      daySums[i].insertAdjacentHTML('afterbegin', `${eachSums[i].innerHTML}円`);
    };
  };
};

function removeBottomRow (bottom, bottomLeft, rows) {
  if (bottomLeft.getAttribute("style") == "background-color: lightgrey;") {
    for (let i=0; i < rows.length; i++) {
      rows[i].setAttribute("style", "height: calc(100% / 5);")
    };
    bottom.setAttribute("style", "display: none;");
  };
};

function setTodayColor (displayYear, displayMonth, thisMonths) {
  const today = new Date();
  if (today.getFullYear() == displayYear && today.getMonth()+1 == displayMonth) {
    thisMonths[today.getDate()-1].setAttribute("style", "background-color: yellow;")
  };
};