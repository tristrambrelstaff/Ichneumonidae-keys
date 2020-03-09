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


# Just pass through var=val pairs:
match($0, /^[[:blank:]]*([[:alpha:]][_[:alnum:]]*)[[:blank:]]*=(.*)$/, arr) {
  var = toupper(arr[1])
  val = trim(arr[2])
  printf "%s=%s\n", var, val
  if (var == "TYPE") {
    type = val
  }
}


# Line 1 of Couplets:
FNR == 1 && match($0, /^[[:blank:]]*([[:digit:]][_[:alnum:]]*)[[:blank:]]*\(?([^\)]*).*$/, arr) {
  id = arr[1]
  id_fail = trim(arr[2])
  expecting = "property"
  if (id_fail == "") {
    type = "couplet"
    printf "TYPE=%s\n", type
    printf "ID=%s\n", id
  } else {
    type = "split_couplet"
    pass_id = id + 1
    printf "TYPE=%s\n", type
    printf "ID=%s\n", id
    printf "ID_FAIL=%s\n", id_fail
  }
}


END {
  sprintf("dirname %s", FILENAME) | getline curdir
  switch (tolower(type)) {
    case "project":
      get_subdirnames(curdir, docs)
      for (d in docs) {
        printf "DOC=%s\n", docs[d]
      }
      break
    case "doc":
      get_subdirnames(curdir, keys)
      for (k in keys) {
        if (keys[k] != "figures") {
          printf "KEY=%s\n", keys[k]
        }
      }
      figdir = sprintf("%s/figures", curdir)
      get_txtfilenames(figdir, figs)
      for (f in figs) {
        printf "FIG=%s\n", figs[f]
      }
      break
    case "key":
      get_txtfilenames(curdir, couplets)
      for (c in couplets) {
        if (couplets[c] != "key") {
          printf "COUPLET=%s\n", couplets[c]
        }
      }
      break
    case "fig":
      break
    case "couplet":
      break
    case "split_couplet":
      break
    default:
      break
  }
}
