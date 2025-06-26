module.exports = {
  root: true,
  parser: "@typescript-eslint/parser",
  plugins: ["@typescript-eslint", "prettier"],
  extends: [
    "eslint:recommended",
    "plugin:@typescript-eslint/recommended",
    "plugin:prettier/recommended" // must be last
  ],
  env: { node: true, es2023: true },
  rules: {
    "@typescript-eslint/explicit-module-boundary-types": "off"
  },
  ignorePatterns: ["artifacts/", "cache/", "out/", "node_modules/"]
};
