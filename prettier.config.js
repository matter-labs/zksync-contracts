/** @type {import('prettier').Config} */
module.exports = {
  printWidth: 100,
  tabWidth: 2,
  semi: true,
  singleQuote: false,
  plugins: ["prettier-plugin-solidity"],
  overrides: [
    {
      files: "*.sol",
      options: {
        solidityBracketSpacing: true,
        soliditySingleQuote: false,
        soliditySortImports: true,
      },
    },
  ],
};
