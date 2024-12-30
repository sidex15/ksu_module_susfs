/** @type {import('tailwindcss').Config} */

module.exports = {
  content: [
    "./*.html",
    "./*.{js,ts,jsx,tsx}",
    "./src/**/*.{js,ts,jsx,tsx}",
  ],
  theme: {
    extend: {
      fontFamily: {
        amongus: ['amongus', 'sans-serif'],
        amongus2: ['amongus2', 'sans-serif'], // Define custom font family
      },
    },
  },
  plugins: [
    require('daisyui'),
  ],
}
