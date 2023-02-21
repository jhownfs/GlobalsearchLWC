# Salesforce Global Search Component

This component is to using like Salesforce global search, but some differences.

### 💻 How I to use?

If you can you this component, clone this repository and push using SFDX to your org, follow instructions:

If you have suggestion, please make a pull request.

### 🚀 Next steps

- [] Improve Front End UX/UI
- [] Improve Back End Sync/Async
- [] Break in small component
- [] Improve README

### Commitlint

This project have commits configured to follow the Conventional Commits's best practice and it's configured with ESLint, Prettier and Stylelint.

To commit, you must follow the convention <type>[optional scope]: <description>. In practice, it would be as follow:

git commit -m "feat: add button component"
Then, Husky will start the pre-commit hook and run lint-staged, who will run prettier, lint and stylelint to validate code format and code lint. If you fail to follow any of these validations, the commit will be aborted.

After that, if everything is validated correctly, Husky will proceed with the commit-msg hook, where it will evaluate if your commit message is following the Conventional Commit's best practice and later run the tests of your project. If any of the tests are broken, the commit will be aborted. You must fix the tests before proceed.

You can also commit your files with the help of the CLI. To do so, just run npm run commit. From there, the CLI will assist you in the proccess. As before: if your changes fails the validation, you must fix it before proceed.

As a best practice, it is strongly recommended that you do not skip the validations. If you need to change the way your commit messages are written, just go to file commitlint.config.ts and you will find there the config needed.

Check out [commitlint](https://commitlint.js.org/#/) docs to see further configurations that you can do.

### Motivation

This project is created only to pratice LWC, Salesforce, Apex, Design Patterns and Software skills.

## 📝 Licença

This project is under license. Se the file [License](LICENSE) for more details.

[⬆ Voltar ao topo](GlobalsearchLWC)<br>
