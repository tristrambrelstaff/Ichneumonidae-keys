function write_ppage(docs, outfile, \
		     d, doc) {
  printf "<!doctype html>\n" > outfile
  printf "<h1>Documents</h1>\n" > outfile
  for (d in docs) {
    doc = docs[d]
    printf "<a href=\"%s/doc.html\">%s</a><br>\n", doc, doc > outfile
  }
  close(outfile)
}


function get_params(params_file, params, \
                    line, parts) {
  while((getline line < params_file) > 0) {
    if (match(line, /^([[:alnum:]_]+)\s*=\s*(.*)/, parts) > 0) {
      label = toupper(parts[1])
      if (label in params) {
        params[label] = sprintf("%s\n%s", params[label], parts[2])
      } else {
        params[label] = parts[2]
      }
    }
  }
}


function write_dpage(infile, doc, keys, outfile, \
		     params, k, key) {
  get_params(infile, params)
  printf "<!doctype html>\n" > outfile
  printf "<h1>Document: %s</h1>\n", doc > outfile
  printf "<h2>Citation</h2>\n" > outfile
  printf "%s\n", params["CITATION"] > outfile
  printf "<h2>Sources</h2>\n" > outfile
  printf "<a href=\"%s\">Original Copy</a><br>\n", params["ORIGINAL_COPY"] > outfile
  printf "<a href=\"%s\">Original Page</a><br>\n", params["ORIGINAL_PAGE"] > outfile
  printf "<a href=\"%s\">Archived Copy</a><br>\n", params["ARCHIVED_COPY"] > outfile
  printf "<a href=\"%s\">Archived Page</a><br>\n", params["ARCHIVED_PAGE"] > outfile
  printf "<h2>Keys</h2>\n" > outfile
  for (k in keys) {
    key = keys[k]
    printf "<a href=\"%s/key.html\">%s</a><br>\n", key, key > outfile
  }
  printf "<h2>Figures</h2>\n" > outfile
  printf "### TODO ###\n" > outfile
  close(outfile)
}


function write_kpage(infile, key, couplets, outfile, \
		     params, n, note, c, couplet) {
  get_params(infile, params)
  printf "<!doctype html>\n" > outfile
  printf "<h1>Key: %s</h1>\n", key > outfile
  printf "<h2>Title</h2>\n" > outfile
  printf "%s\n", params["TITLE"] > outfile
  printf "<h2>Note</h2>\n" > outfile
  split(params["NOTE"], notes, "\n")
  for (n in notes) {
    note = notes[n]
    printf "<div>%s</div>", note > outfile
  }
  printf "<h2>Couplets</h2>\n" > outfile
  for (c in couplets) {
    couplet = couplets[c]
    printf "<a href=\"%s.html\">%s</a> ", couplet, couplet > outfile
  }
  close(outfile)
}


function write_cpage(infile, couplet, outfile) {
  printf "<!doctype html>\n" > outfile
  printf "<h1>Couplet: %s</h1>\n", couplet > outfile
  ### Read Couplet File
  close(outfile)
}


function get_subdirs(dir, arr) {
  sprintf("cd %s; ls -dv */ 2>/dev/null | sed s#/##g | xargs", dir) | getline line
  split(line, arr)
}


function get_couplet_files(dir, arr) {
  sprintf("cd %s; ls -v *.txt 2>/dev/null | grep -v key.txt | sed s/.txt//g | xargs", dir) | getline line
  split(line, arr)
}


BEGIN {
  pdir = ENVIRON["PWD"]
  get_subdirs(pdir, docs)
  write_ppage(docs, pdir "/project.html")
  for (d in docs) {
    doc = docs[d]
    ddir = pdir "/" doc
    get_subdirs(ddir, keys)
    write_dpage(ddir "/doc.txt", doc, keys, ddir "/doc.html")
    for (k in keys) {
      key = keys[k]
      kdir = ddir "/" key
      get_couplet_files(kdir, couplets)
      write_kpage(kdir "/key.txt", key, couplets, kdir "/key.html")
      for (c in couplets) {
        couplet = couplets[c]
        write_cpage(kdir "/" couplet ".txt", couplet, kdir "/" couplet ".html")
      }
    }
  }
}
