# Global Search Component ![image](https://img.shields.io/badge/Salesforce-00A1E0?style=for-the-badge&logo=Salesforce&logoColor=white)

This component is to using like Salesforce global search, but some differences.

## 💻 How I to use?

If you can you this component, clone this repository and push using SFDX to your org, follow instructions:

1. Clone this repository:

```
git clone https://github.com/jhownfs/GlobalsearchLWC.git
cd GlobalsearchLWC
```

2. Authorize with your org and provide it with an alias (OrgAlias):

```
sfdx force:auth:web:login -a "OrgAlias"
```

3. Push the app to your org:

```
sfdx force:source:deploy --sourcepath force-app/main/default --json --loglevel fatal --targetusername "OrgAlias"
```

4. Open the default org:

```
sfdx force:org:open --targetusername "OrgAlias"
```

If you have suggestion to improve it, please make a pull request.

## 🚀 Next steps

- [] Improve Front End UX/UI
- [] Improve Back End Sync/Async
- [] Break in small component
- [] Improve README

## Lint-staged

Linting makes more sense when run before committing your code. By doing so you can ensure no errors go into the repository and enforce code style. But running a lint process on a whole project is slow, and linting results can be irrelevant. Ultimately you only want to lint files that will be committed.

This project contains a script that will run arbitrary shell tasks with a list of staged files as an argument, filtered by a specified glob pattern.

For more information access >> [Lint-staged](https://github.com/okonet/lint-staged)

## Motivation

This project is created only to pratice LWC, Salesforce, Apex, Design Patterns and Software skills.

## 📝 Licença

This project is under license. Se the file [License](LICENSE) for more details.

[⬆ Voltar ao topo](https://github.com/jhownfs/GlobalsearchLWC.git)<br>
