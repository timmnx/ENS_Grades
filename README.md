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
│   └── infos.yaml
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

## `infos.yaml`
General informations about the author, the student and the school year. *(see example files)*

## `main.typ`
The main file is just:
```
#import "ENS_Grades.typ": doc

#show: doc.with(
  file_infos: "<infos>",
  file_grades: "<grades>",
)
```
where `<infos>` and `<grades>` are just the names for the infos and grades files.

*For example:* if we have the following structure:
```
ENS_Grades/
├── grades
│   └── grades_L3.yaml
├── infos
│   └── infos_L3.yaml
...
```
- `<grades>` = `grades_L3`
- `<infos>` = `infos_L3`

There is no need to write the full path and the extension.

# Results
There are two examples for L3 and M1 grades with fictives grades and informations, and with their respective `pdf`.