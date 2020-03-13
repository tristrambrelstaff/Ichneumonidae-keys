BEGIN {
  printf "<!doctype html>\n"
}


match($0, /^[[:blank:]]*([[:alpha:]][_[:alnum:]]*)[[:blank:]]*=(.*)$/, arr) {
  var = arr[1]
  val = arr[2]
  switch(type) {
    case "project":
      ###
      break
    case "doc":
      ###
      break
    case "key":
      ###
      break
    case "fig":
      ###
      break
    case "couplet":
      ###
      break
    case "split_couplet":
      switch (var) {
        case "ID":
          id = val
          printf "<table>\n<tr>\n<td>%s", id
          break
        case "ID_FAIL":
          id_fail = val
          printf " (%s)</td>\n<td>", id_fail
          break
        case "TEST":
          test = val
          printf "<td>%s</td>\n<td>", test
          break
        case "TAXON":
          taxon = val
          printf taxon
          break
        case "NOTE":
          note = val
          printf note
        default:
          break
      }
      break
    case "":
      type = val
      break
    default:
      break
  }
}


END {
  switch(type) {
    case "project":
      ###
      break
    case "doc":
      ###
      break
    case "key":
      ###
      break
    case "fig":
      ###
      break
    case "couplet":
      ###
      break
    case "split_couplet":
      printf "</td>\n</tr>\n</table>\n"
      break
    default:
      break
  }
}
