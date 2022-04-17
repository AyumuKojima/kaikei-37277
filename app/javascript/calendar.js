window.addEventListener("turbolinks:load", calendar);

function calendar () {
  const displayYear = document.getElementById("display-year").innerHTML;
  const displayMonth = document.getElementById("display-month").innerHTML;
  const dates = document.querySelectorAll(".date");
  const wDayNum = document.getElementById("wday_num").innerHTML;
  if (dates[0].innerHTML == "") {
    setDateNumber(displayYear, displayMonth, dates, wDayNum);
  };

  const thisMonthSumData = document.querySelectorAll(".this-month-sum-data");
  const thisMonthSums = document.querySelectorAll(".this-month-sum");
  setMonthSums(thisMonthSumData, thisMonthSums);

  const lastMonthSumData = document.querySelectorAll(".last-month-sum-data");
  const lastMonthSums = document.querySelectorAll(".last-month-sum");
  setLastMonthSums(lastMonthSumData, lastMonthSums);

  const nextMonthSumData = document.querySelectorAll(".next-month-sum-data");
  const nextMonthSums = document.querySelectorAll(".next-month-sum");
  setMonthSums(nextMonthSumData, nextMonthSums);
  
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
  const borderStyle = "border:3px solid deeppink;";

  changeFormToLastMonth(lastMonths, lastMonthDates, yearForm, monthForm, dayForm, displayYear, displayMonth, dates, borderStyle);
  changeFormToThisMonth(thisMonths, thisMonthDates, yearForm, monthForm, dayForm, displayYear, displayMonth, dates, borderStyle);
  changeFormToNextMonth(nextMonths, nextMonthDates, yearForm, monthForm, dayForm, displayYear, displayMonth, dates, borderStyle);

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
      dates[i].insertAdjacentHTML('afterbegin', `<div class='date-num last-month-date'>${k}</div><div class='day-sum last-month-sum'></div>`);
      k += 1;
      w += 1;
      dates[i].setAttribute("style", "background-color:lightgrey;");
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
      dates[i].insertAdjacentHTML('afterbegin', `<div class='date-num this-month-date'>${k}</div><div class='day-sum this-month-sum'></div>`);
      k += 1;
      if (k > getDayNum(year, month)) {
        k = 1;
        flag = 3;
      };
    } else {
      dates[i].setAttribute("class", "date next-month")
      dates[i].insertAdjacentHTML('afterbegin', `<div class='date-num next-month-date'>${k}</div><div class='day-sum next-month-sum'></div>`);
      k += 1;
      dates[i].setAttribute("style", "background-color:lightgrey;");
    };
  };
};

function setMonthSums (monthSumData, monthSums) {
  for (let i=0; i < monthSums.length; i++) {
    if (monthSumData[i].innerHTML != 0 && monthSums[i].innerHTML == "") {
      monthSums[i].insertAdjacentHTML('afterbegin', `${monthSumData[i].innerHTML}円`);
    };
  };
};

function setLastMonthSums (lastMonthSumData, lastMonthSums) {
  let k = 0
  for (let i=0; i < lastMonthSums.length; i++) {
    k = lastMonthSumData.length - lastMonthSums.length + i;
    if (lastMonthSumData[k].innerHTML != 0 && lastMonthSums[i].innerHTML == "") {
      lastMonthSums[i].insertAdjacentHTML('afterbegin', `${lastMonthSumData[k].innerHTML}円`);
    };
  };
};


function removeBottomRow (bottom, bottomLeft, rows) {
  if (bottomLeft.getAttribute("style") == "background-color:lightgrey;") {
    for (let i=0; i < rows.length; i++) {
      rows[i].setAttribute("style", "height: calc(100% / 5);")
    };
    bottom.setAttribute("style", "display: none;");
  };
};

function setTodayColor (displayYear, displayMonth, thisMonths) {
  const today = new Date();
  if (today.getFullYear() == displayYear && today.getMonth()+1 == displayMonth) {
    thisMonths[today.getDate()-1].setAttribute("style", "background-color:yellow;")
  };
};

function cancelBorder (dates, borderStyle) {
  for (let k=0; k < dates.length; k++) {
    if (dates[k].getAttribute("style") == `background-color:lightgrey; ${borderStyle}`) {
      dates[k].setAttribute("style", "background-color:lightgrey")
    } else if (dates[k].getAttribute("style") == `background-color:yellow; ${borderStyle}`) {
      dates[k].setAttribute("style", "background-color:yellow;");
    } else if (dates[k].getAttribute("style") == borderStyle) {
      dates[k].removeAttribute("style");
    };
  };
};

function changeFormToLastMonth (lastMonths, lastMonthDates, yearForm, monthForm, dayForm, displayYear, displayMonth, dates, borderStyle) {
  for (let j=0; j < lastMonths.length; j++) {
    lastMonths[j].addEventListener('click', () => {
      cancelBorder(dates, borderStyle);
      lastMonths[j].setAttribute("style", `background-color:lightgrey; ${borderStyle}`);
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
};

function changeFormToThisMonth (thisMonths, thisMonthDates, yearForm, monthForm, dayForm, displayYear, displayMonth, dates, borderStyle) {
  for (let i=0; i < thisMonths.length; i++) {
    thisMonths[i].addEventListener('click', () => {
      cancelBorder(dates, borderStyle);
      if (thisMonths[i].getAttribute("style") == `background-color:yellow;`) {
        thisMonths[i].setAttribute("style", `background-color:yellow; ${borderStyle}`);
      } else {
        thisMonths[i].setAttribute("style", borderStyle);
      }
      yearForm.value = displayYear;
      monthForm.value = displayMonth;
      dayForm.value = thisMonthDates[i].innerHTML;
    });
  };
};

function changeFormToNextMonth (nextMonths, nextMonthDates, yearForm, monthForm, dayForm, displayYear, displayMonth, dates, borderStyle) {
  for (let n=0; n < nextMonths.length; n++) {
    nextMonths[n].addEventListener('click', () => {
      cancelBorder(dates, borderStyle);
      nextMonths[n].setAttribute("style", `background-color:lightgrey; ${borderStyle}`);
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
}