export const DEFAULT_STUDY_PERIOD = "2026-2027";
export const DEFAULT_STUDY_CATEGORY = "2-3";

export const STUDY_CATEGORIES = Object.freeze([
  { value: "2-3", label: "Clasele 2–3" },
  { value: "4-5", label: "Clasele 4–5" },
  { value: "6-7", label: "Clasele 6–7" },
  { value: "8-9", label: "Clasele 8–9" },
  { value: "10-11", label: "Clasele 10–11" },
  { value: "12-plus", label: "Clasa 12 – nelimitat" },
]);

export const STUDY_PERIODS = Object.freeze([
  "2019-2020",
  "2020-2021",
  "2021-2022",
  "2022-2023",
  "2023-2024",
  "2024-2025",
  "2025-2026",
  "2026-2027",
  "2027-2028",
  "2028-2029",
]);

export const STUDY_PLAN = Object.freeze({
  "2019-2020": {
    memorare: "Apocalipsa, cap. 13, 19, 20, 21, 22 (97 versete)",
    categories: {
      "2-3": ["Matei", "Iona"],
      "4-5": ["Matei", "Iona"],
      "6-7": ["Matei", "Proverbe cap. 1–6"],
      "8-9": ["Matei", "Iona", "Maleahi"],
      "10-11": ["Matei", "Maleahi", "Psalmi (cartea I) cap. 1–41"],
      "12-plus": ["Matei", "Maleahi", "Psalmi (cartea I) cap. 1–41"],
    },
  },
  "2020-2021": {
    memorare: "2 Timotei, cap. 1, 2, 3, 4 (83 versete)",
    categories: {
      "2-3": ["Genesa", "2 Ioan"],
      "4-5": ["Genesa", "2 Tesaloniceni"],
      "6-7": ["Genesa", "1 Tesaloniceni"],
      "8-9": ["Genesa", "1 & 2 Tesaloniceni"],
      "10-11": ["Genesa", "1 Tesaloniceni", "Eclesiastul"],
      "12-plus": ["Genesa", "1 Tesaloniceni", "Cântarea Cântărilor"],
    },
  },
  "2021-2022": {
    memorare: "Matei, cap. 5, 6, 7 (111 versete)",
    categories: {
      "2-3": ["Marcu", "Estera", "Filimon"],
      "4-5": ["Marcu", "Iosua cap. 1–11 și 20–24"],
      "6-7": ["Marcu", "Proverbe cap. 7–12"],
      "8-9": ["Marcu", "Iosua cap. 1–11 și 20–24", "Estera"],
      "10-11": ["Marcu", "Judecători", "Psalmi (cartea II) cap. 42–72"],
      "12-plus": ["Marcu", "Judecători", "Psalmi (cartea II) cap. 42–72"],
    },
  },
  "2022-2023": {
    memorare: "Evrei, cap. 11, 12, 13 (94 versete)",
    categories: {
      "2-3": ["Exod", "3 Ioan"],
      "4-5": ["Exod", "1 Timotei"],
      "6-7": ["Exod", "2 Timotei"],
      "8-9": ["Exod", "1 & 2 Timotei"],
      "10-11": ["Exod", "1 Timotei", "Iov cap. 1–22"],
      "12-plus": ["Exod", "1 Timotei", "Iov cap. 1–22"],
    },
  },
  "2023-2024": {
    memorare: "1 Timotei, cap. 1, 2, 3, 4, 5, 6 (113 versete)",
    categories: {
      "2-3": ["Luca", "Daniel cap. 1–6"],
      "4-5": ["Luca", "Iuda", "Daniel cap. 1–6"],
      "6-7": ["Luca", "Tit", "Isaia cap. 1, 53, 55, 58"],
      "8-9": ["Luca", "2 Ioan", "Proverbe cap. 13–18"],
      "10-11": ["Luca", "Iacov", "Psalmi (cartea III) cap. 73–89"],
      "12-plus": ["Luca", "Iacov", "Psalmi (cartea III) cap. 73–89"],
    },
  },
  "2024-2025": {
    memorare: "Filipeni, cap. 1, 2, 3, 4 (104 versete)",
    categories: {
      "2-3": ["Deuteronom", "1 Ioan"],
      "4-5": ["Deuteronom", "Efeseni"],
      "6-7": ["Deuteronom", "Romani"],
      "8-9": ["Deuteronom", "Romani", "1 Corinteni"],
      "10-11": ["Deuteronom", "1 Corinteni", "Iov cap. 23–42"],
      "12-plus": ["Deuteronom", "1 Corinteni", "Iov cap. 23–42"],
    },
  },
  "2025-2026": {
    memorare: "Ioan, cap. 14, 15, 16 (91 versete)",
    categories: {
      "2-3": ["Ioan", "Rut"],
      "4-5": ["Ioan", "Numeri cap. 12–14, 16–17, 22–25"],
      "6-7": ["Ioan", "Rut", "Levitic cap. 23–27"],
      "8-9": ["Ioan", "3 Ioan", "Proverbe cap. 19–24"],
      "10-11": ["Ioan", "Levitic cap. 23–27", "Psalmi (cartea IV) cap. 90–106"],
      "12-plus": ["Ioan", "Levitic cap. 23–27", "Psalmi (cartea IV) cap. 90–106"],
    },
  },
  "2026-2027": {
    memorare: "Apocalipsa, cap. 1, 2, 3, 4, 5 (96 versete)",
    categories: {
      "2-3": ["1 & 2 Samuel", "Iuda"],
      "4-5": ["1 & 2 Samuel", "1 Petru"],
      "6-7": ["1 & 2 Samuel", "Filipeni"],
      "8-9": ["1 & 2 Samuel", "Galateni"],
      "10-11": ["1 & 2 Samuel", "Evrei"],
      "12-plus": ["1 & 2 Samuel", "Evrei"],
    },
  },
  "2027-2028": {
    memorare: "1 Tesaloniceni, cap. 1, 2, 3, 4, 5 (89 versete)",
    categories: {
      "2-3": ["Faptele Apostolilor", "Ezra cap. 1, 3–7, 9"],
      "4-5": ["Faptele Apostolilor", "Ezra cap. 1, 3–7, 9", "3 Ioan"],
      "6-7": ["Faptele Apostolilor", "Neemia cap. 1–6, 8–9, 13"],
      "8-9": ["Faptele Apostolilor", "Neemia cap. 1–6, 8–9, 13", "Iuda"],
      "10-11": ["Faptele Apostolilor", "Ezra cap. 1, 3–7, 9", "Proverbe cap. 25–31"],
      "12-plus": ["Faptele Apostolilor", "Ezra cap. 1, 3–7, 9", "Psalmi (cartea V) cap. 107–150"],
    },
  },
  "2028-2029": {
    memorare: "Faptele Apostolilor, cap. 1, 2, 3 (99 versete)",
    categories: {
      "2-3": ["1 & 2 Împărați", "Filimon"],
      "4-5": ["1 & 2 Împărați", "2 Petru"],
      "6-7": ["1 & 2 Împărați", "Coloseni"],
      "8-9": ["1 & 2 Împărați", "2 Corinteni"],
      "10-11": ["1 & 2 Împărați", "2 Corinteni"],
      "12-plus": ["1 & 2 Împărați", "2 Corinteni"],
    },
  },
});

export function getStudyCategory(value) {
  return STUDY_CATEGORIES.find((category) => category.value === value) || STUDY_CATEGORIES[0];
}

export function getStudyPlan(period = DEFAULT_STUDY_PERIOD) {
  return STUDY_PLAN[period] || STUDY_PLAN[DEFAULT_STUDY_PERIOD];
}

export function getStudyBooks(period = DEFAULT_STUDY_PERIOD, category = DEFAULT_STUDY_CATEGORY) {
  return getStudyPlan(period).categories[category] || getStudyPlan(period).categories[DEFAULT_STUDY_CATEGORY] || [];
}
