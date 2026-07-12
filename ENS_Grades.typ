#let doc(
  file_author: "infos/author.yaml",
  file_student: "infos/student.yaml",
  file_year: "infos/year.yaml",
  file_grades: "grades/grades.yaml",
  body,
) = {
  set page(
    paper: "a4",
    margin: 2cm,
    footer: text(gray, 7pt)[
      École normale supérieure de Rennes

      Campus de Ker lann, 11 Av. Robert Schuman, 35170 Bruz

      +33 (0)2 99 05 93 00
    ],
  )

  set par(justify: true)
  set text(font: "Helvetica", weight: "medium", 9pt)

  let author = yaml(file_author)
  let student = yaml(file_student)
  let year = yaml(file_year)
  let grades = yaml(file_grades)

  let get(x) = text(rgb(63, 82, 160), x)

  let grade_to_letter_gpa(grade) = {
    if (grade == none or grade >= 16) { ("A+", 4.33) } else if grade >= 14 { ("A", 4.0) } else if grade >= 13 {
      ("A-", 3.67)
    } else if (grade >= 12) { ("B+", 3.33) } else if grade >= 11 { ("B", 3.0) } else if grade >= 10 {
      ("B-", 2.67)
    } else if grade >= 9 { ("C+", 2.33) } else if grade >= 8 { ("C", 2.0) } else if grade >= 7 { ("C-", 1.67) } else {
      ("F", 4.33)
    }
  }

  let show_ects(ects_awarded, max_ects) = {
    let (star, show_star) = {
      if ects_awarded < max_ects { ("*", true) } else { ("", false) }
    }
    (str(ects_awarded) + "/" + str(max_ects) + star, show_star)
  }

  let compute_semester(s, i, r) = {
    let results = r
    // init values
    let total_max_ects = 0
    let total_ects_awarded = 0
    let total_ects_accounted = 0
    let total_grades = 0
    let total_gpa = 0
    let show_star = false
    // for loop
    for value in s {
      let grade_20 = value.at("grade_20", default: none)
      let ects_awarded = {
        if value.at("ects", default: none) == none {
          if grade_20 < 10 { 0 } else { value.max_ects }
        } else { value.ects }
      }
      let (letter_grade, gpa) = grade_to_letter_gpa(grade_20)
      total_max_ects += value.max_ects
      total_ects_awarded += ects_awarded
      total_gpa += gpa * value.max_ects
      let str_grade_20 = {
        if grade_20 != none {
          total_ects_accounted += value.max_ects
          total_grades += grade_20 * value.max_ects
          str(grade_20)
        } else { "" }
      }
      let (str_ects, ects_show_star) = show_ects(ects_awarded, value.max_ects)
      show_star = show_star or ects_show_star
      let line = (
        value.course,
        value.title,
        str_ects,
        str_grade_20,
        letter_grade,
        str(gpa),
      )
      results.push(line)
    }
    let mean = calc.round(total_grades / total_ects_accounted, digits: 3)
    if mean >= 10 {
      total_ects_awarded = total_max_ects
    }
    let (letter, _) = grade_to_letter_gpa(mean)
    let gpas = calc.round(total_gpa / total_ects_awarded, digits: 2)
    results.push(
      (
        "",
        "<b>Semester " + str(i) + "</b>",
        "<b>" + str(total_ects_awarded) + "</b>",
        "<b>" + str(mean) + "</b>",
        "<b>" + letter + "</b>",
        "<b>" + str(calc.round(gpas, digits: 2)) + "</b>",
      ),
    )
    (
      total_ects_awarded: total_ects_awarded,
      total_max_ects: total_max_ects,
      mean: mean,
      gpas: gpas,
      show_star: show_star,
      results: results,
    )
  }

  let compute(g) = {
    let results = (
      (
        "Course",
        "Title",
        "Credits\nAwarded",
        "Grade out\nof 20",
        "Letter\nGrade",
        "GPA",
      ),
    )
    let s1 = compute_semester(g.FirstSemester, 1, results)
    let s2 = compute_semester(g.SecondSemester, 2, s1.results)
    // let results = s2.results
    let mean = (s1.mean + s2.mean) / 2
    let gpas = (s1.gpas + s2.gpas) / 2
    let total_ects_awarded = {
      if mean >= 10 {
        s1.total_max_ects + s2.total_max_ects
      } else { s1.total_ects_awarded + s2.total_ects_awarded }
    }
    let (letter, _) = grade_to_letter_gpa(mean)
    // results.join(s1.results)
    // results.join(s2.results)
    s2.results.push(
      (
        "TOTAL",
        "",
        str(total_ects_awarded),
        str(calc.round(mean, digits: 3)),
        letter,
        str(calc.round(gpas, digits: 2)),
      ),
    )
    (s1.show_star or s2.show_star, s2.results)
  }

  show regex("\\d[t][h]"): x => {
    x.text.replace("th", "")
    super("th")
  }
  show regex("\\d[s][ht]"): x => {
    x.text.replace("st", "")
    super("st")
  }
  show regex("\\d[n][hd]"): x => {
    x.text.replace("nd", "")
    super("nd")
  }
  show regex("\\d[r][d]"): x => {
    x.text.replace("rd", "")
    super("rd")
  }
  show regex("<i>.*</i>"): x => emph(x.text.replace("<i>", "").replace("</i>", ""))
  show regex("<b>.*</b>"): x => strong(x.text.replace("<b>", "").replace("</b>", ""))

  grid(
    columns: (30%, 70%),
    align: (left + horizon, right + horizon),
    image("logo.png"),
    box[
      #align(center)[
        #title[Transcript of academic record]
        *#year.yearname\ Course "#year.name" (#year.course)*
      ]
    ],
  )

  [#get(student.gender) #get(student.name) #get(student.firstname), born on the #get(student.dob), in #get(student.pob), studied at the _École normale supérieure de Rennes_ (Bruz, France) in #get(year.schoolyear) where #get(student.pronoun) attended and passed the following courses:]

  let (show_star, computed_grades) = compute(grades)

  show table: set text(8pt)
  show table.cell.where(y: 0): strong
  show table.cell.where(y: computed_grades.len() - 1): strong

  table(
    columns: (auto, 1fr, 12%, 12%, 12%, 12%),
    inset: 6pt,
    align: (x, y) => (
      horizon
        + {
          if (y == 0 or x > 1) { center }
        }
    ),
    stroke: (x, y) => (
      top: if y == 0 { 1pt } else { if y == computed_grades.len() - 1 { 2pt } else { 0.5pt } },
      bottom: if y == computed_grades.len() - 1 { 1pt } else { 0.5pt },
      left: if x == 0 { 1pt } else { 0.5pt },
      right: if x == 5 { 1pt } else { 0.5pt },
    ),
    fill: (x, y) => if (y == 0 or y == computed_grades.len() - 1) { silver },
    table.header(..computed_grades.at(0)),
    ..computed_grades.slice(1).flatten(),
  )

  [
    #if show_star {
      text(
        size: 7pt,
      )[_\*This course unit is not validated (ECTS credits not awarded). The academic year is validated by compensation, on
      the basis of the overall average grade._]
    }

    _NB:_ _École normale supérieure de Rennes_ is one of the most selective French higher education institutions in science and humanities. Students entering ENS are selected from the upper tier of classes préparatoires and universities and ranked in the top 1-5% among French students.

    ENS follows the traditional French grading system based on a numbered scale from 0 to 20, 10 being the minimum passing grade. Grades given at our department correspond to the following:
    - 16-20: Outstanding
    - 14-15.99: Very Good
    - 12-13.99: Good
    - 10-11.99: Fair
    - < 10: Fail

    Typical class average lies between 12 and 14/20 and grades above 16 are seldom awarded.

    I, #get(author.gender) #get(author.name) #get(author.firstname), #get(author.status) in #get(author.field), #get(author.title), hereby certify that the translation of the transcripts obtained by #get(student.gender) #get(student.name) #get(student.firstname) is true to the original.

    #datetime.today().display("[month repr:long] [day], [year]")]

  // place(bottom, text(gray, 6pt)[
  //   École normale supérieure de Rennes\
  //   Campus de Ker lann, 11 Av. Robert Schuman, 35170 Bruz\
  //   +33 (0)2 99 05 93 00
  // ])
}
