function trim(str) {
  gsub(/^[[:blank:]]*/, "", str)
  gsub(/[[:blank:]]*$/, "", str)
  return str
}


function get_subdirnames(dir, arr) {
  sprintf("cd %s; ls -dv */ 2>/dev/null | sed s#/##g | xargs", dir) | getline line
  split(line, arr)
}


function get_txtfilenames(dir, arr) {
  sprintf("cd %s; ls -v *.txt 2>/dev/null | sed s/.txt//g | xargs", dir) | getline line
  split(line, arr)
}


# Just pass through k=v pairs:
match($0, /^[[:blank:]]*([[:alpha:]][_[:alnum:]]*)[[:blank:]]*=(.*)$/, arr) {
  k = toupper(arr[1])
  v = trim(arr[2])
  printf "%s=%s\n", k, v
  if (k == "TYPE") {
    type = v
  }
}


END {
  switch (tolower(type)) {
    case "project":
      get_subdirnames("./", docs)
      for (d in docs) {
        printf "DOC=%s\n", docs[d]
      }
      break
    case "doc":
      break
    case "key":
      break
    case "couplet":
      break
    case "split_couplet":
      break
    default:
      break
  }
}
