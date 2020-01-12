function get_subdirectory_names(dir, arr) {
  sprintf("cd %s; ls -dv */ 2>/dev/null | sed s#/##g | xargs", dir) | getline line
  split(line, arr)
}

function get_txt_file_names(dir, arr) {
  sprintf("cd %s; ls -v *.txt 2>/dev/null | sed s/.txt//g | xargs", dir) | getline line
  split(line, arr)
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
  close(params_file)
}

function build_couplet_page(doc, key, couplet) {
  ### TODO ###
}

function build_key_page(doc, key, \
  params, outfile, k, couplets) {
  get_params(sprintf("%s/%s/key.txt", doc, key), params)
  outfile = sprintf("%s/%s/key.html", doc, key)
  printf "<!doctype html>\n" > outfile
  printf "<h1>Key: %s %s</h1>\n", doc, key > outfile
  printf "<h2>Title</h2>\n" > outfile
  printf "%s\n", params["TITLE"] > outfile
  printf "<h2>Notes</h2>\n" > outfile
  split(params["NOTES"], notes, "\n")
  for (n in notes) {
    printf "<div class=\"note\">%s</div>", notes[n] > outfile
  }
  printf "<h2>Couplets</h2>\n" > outfile
  get_txt_file_names(sprintf("%s/%s", doc, key), couplets)
  for (k in couplets) {
    if (couplets[k] != "key") {
      printf "<a href=\"%s.html\">%s</a> ", couplets[k], couplets[k] > outfile
      build_couplet_page(doc, key, couplets[j])
    }
  }
  close(outfile)
}

function build_doc_page(doc, \
  params, outfile, keys) {
  get_params(sprintf("%s/doc.txt", doc), params)
  outfile = sprintf("%s/doc.html", doc)
  printf "<!doctype html>\n" > outfile
  printf "<h1>Document: %s</h1>\n", doc > outfile
  printf "<h2>Citation</h2>\n" > outfile
  printf "%s\n", params["CITATION"] > outfile
  printf "<h2>Sources</h2>\n" > outfile
  printf "<a href=\"%s\" class=\"original_copy\">Original Copy</a><br>\n", params["ORIGINAL_COPY"] > outfile
  printf "<a href=\"%s\" class=\"original_page\">Original Page</a><br>\n", params["ORIGINAL_PAGE"] > outfile
  printf "<a href=\"%s\" class=\"archived_copy\">Archived Copy</a><br>\n", params["ARCHIVED_COPY"] > outfile
  printf "<a href=\"%s\" class=\"archived_page\">Archived Page</a><br>\n", params["ARCHIVED_PAGE"] > outfile
  printf "<h2>Keys</h2>\n" > outfile
  get_subdirectory_names(doc, keys)
  for (j in keys) {
    printf "<a href=\"%s/key.html\">%s</a><br>\n", keys[j], keys[j] > outfile
    build_key_page(doc, keys[j])
  }
  printf "<h2>Figures</h2>\n" > outfile
  printf "### TODO ###\n" > outfile
  close(outfile)
}

function build_docs_page(docs, \
  outfile, i) {
  outfile = "docs.html"
  printf "<!doctype html>\n" > outfile
  printf "<h1>Documents</h1>\n" > outfile
  for (i in docs) {
    printf "<a href=\"%s/doc.html\">%s</a><br>\n", docs[i], docs[i] > outfile
  }
  close(outfile)
}

BEGIN {
  get_subdirectory_names(".", docs)
  build_docs_page(docs)
  for (i in docs) {
    build_doc_page(docs[i])
  }
}
