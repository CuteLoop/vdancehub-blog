module.exports = {
 content: [
    "./layouts/**/*.html",
    "./content/**/*.{md,html}",
    "./themes/**/layouts/**/*.html", // include theme templates too
    "./assets/**/*.js"
  ],
  safelist: [
    "w-2/3",
    "w-8/12",
    "w-[66.666667%]",
    "mx-auto"
  ],
  theme: { extend: {} },
  plugins: [require("@tailwindcss/typography")],
};
