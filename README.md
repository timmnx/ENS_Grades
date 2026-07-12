# ENS_Grades
A typst module to create a transcript of academic record for student from ENS Rennes.

# How to use

## Structure
First, your project should look like that :
```
ENS_Grades/
├── grades
│   └── grades.yaml
├── infos
│   ├── author.yaml
│   ├── studend.yaml
│   └── year.yaml
├── main.typ
...
```

## `grades.yaml`
Your file should look like that :
```yaml
# First Semester
FirstSemester:
  - <topic>
  - ...

# Second Semester
SecondSemester:
  - <topic>
  - ...
```

Such that each `<topic>` is a mapping with:
- `course`: the short name of the course
- `title`: the title of the course
- `grade_20`: the grade out of 20 *(optional field)*
- `ects`: the number of ECTS awarded *(optional field)*
- `max_ects`: the maximum number of ECTS awardable

If `ects` is not provided, it is automatically computed according to `grade_20`: if `grade_20` >= 10 then `ects` = `max_ects`, else `ects` = 0.

If `grade_20` is not provided, this course won't be used for the computation of the mean.

**Examples:**
```yaml
# First Semester
FirstSemester:
  - course: ALG1
    title: Algorithm 1
    grade_20: 13.11
    max_ects: 6
  - ...

# Second Semester
SecondSemester:
  - course: SEM2
    title: Research Seminar 2
    ects: 2
    max_ects: 2
  - ...
```

## `author.yaml`
General informations about the author. At the time of the creatation of the repo it was:
```yaml
gender: Mr
name: Martin
firstname: QUINSON
status: Full Professor
field: Computer Science
title: Director of the Computer Sciences department
```

## `student.yaml`
General informations about the student. A fictive person for the example:
```yaml
gender: Mme
name: Alice
firstname: BOB
pronoun: she
dob: 29th of February 2004
pob: Paris (FRANCE)
```

## `year.yaml`
General informations about the year. For example:
```yaml
schoolyear: 2024-2025
yearname: Third year of Bachelor's degree in Computer Science
course: SIF
name: Science Informatique
```

## `main.typ`
The main file is just:
```
#import "ENS_Grades.typ": doc

#show: doc.with(
  file_author: <author>,
  file_student: <student>,
  file_year: <year>,
  file_grades: <grades>
)
```
where `<author>`, `<student>`, `<infos>` and `<grades>` are the paths to the files containing the informations.

*For example:* if we have the following structure:
```
ENS_Grades/
├── grades
│   └── grades.yaml
├── infos
│   ├── author.yaml
│   ├── studend.yaml
│   └── year.yaml
...
```
- `<author>` = `infos/author.yaml`
- `<student>` = `infos/student.yaml`
- `<year>` = `infos/year.yaml`
- `<grades>` = `grades/grades.yaml`

*NB:* those values are those by default, *ie* we can simply do `#show: doc.with()` if the files mentionned above exist.

# Results
There are two examples for L3 and M1 grades with fictives grades and informations, and with their respective `pdf`.

# License
This project is being developed for academic use at ENS Rennes (École Normale Supérieure de Rennes) and is widely inspired from the proposition of Emma REDOR (https://emmaredor.github.io/ens-grades.html), aiming for an easier use thanks to `typst` and `yaml` files.