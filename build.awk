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
  sprintf("cd %s; ls -v ./*.txt 2>/dev/null | sed s/.txt//g | xargs", dir) | getline line
  split(line, arr)
}


# Just pass through var=val pairs:
match($0, /^[[:blank:]]*([[:alpha:]][_[:alnum:]]*)[[:blank:]]*=(.*)$/, arr) {
  var = toupper(arr[1])
  val = trim(arr[2])
  printf "%s=%s\n", var, val
  if (var == "TYPE") {
    type = val
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
      get_subdirnames("./", keys)
      for (k in keys) {
        printf "KEY=%s\n", keys[k]
      }
      get_txtfilenames("./figures/", figs)
      for (f in figs) {
        printf "FIG=%s\n", figs[f]
      }
      break
    case "key":
      get_txtfilenames("./", couplets)
      for (c in couplets) {
        printf "COUPLET=%s\n", couplets[c]
      }
      break
    case "couplet":
      break
    case "split_couplet":
      break
    default:
      break
  }
}
