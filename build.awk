function get_subdirectory_names(dir, arr) {
  sprintf("cd %s; ls -dv */ 2>/dev/null | sed s#/##g | xargs", dir) | getline line
  split(line, arr)
}

function get_txt_file_names(dir, arr) {
  sprintf("cd %s; ls -v *.txt 2>/dev/null | sed s/.txt//g | xargs", dir) | getline line
  split(line, arr)
}

function get_config(config_file, config, \
  line, parts) {
  while((getline line < config_file) > 0) {
    if (match(line, /^([[:alnum:]_]+)\s*=\s*(.*)/, parts) > 0) {
      config[toupper(parts[1])] = parts[2]
    }
  }
  close(config_file)
}

function build_couplet_page(doc, key, couplet) {
  ### TODO ###
}

function build_key_page(doc, key, \
  config, outfile, k, couplets) {
  get_config(sprintf("%s/%s/key.txt", doc, key), config)
  outfile = sprintf("%s/%s/key.html", doc, key)
  printf "<!doctype html>\n" > outfile
  printf "<h1>Key: %s %s</h1>\n", doc, key > outfile
  printf "<h2>Title</h2>\n" > outfile
  printf "%s\n", config["TITLE"] > outfile
  printf "<h2>Notes</h2>\n" > outfile
  printf "%s\n", config["NOTES"] > outfile
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
  config, outfile, keys) {
  get_config(sprintf("%s/doc.txt", doc), config)
  outfile = sprintf("%s/doc.html", doc)
  printf "<!doctype html>\n" > outfile
  printf "<h1>Document: %s</h1>\n", doc > outfile
  printf "<h2>Citation</h2>\n" > outfile
  printf "%s\n", config["CITATION"] > outfile
  printf "<h2>Sources</h2>\n" > outfile
  printf "Original Copy: <a href=\"%s\">%s</a><br>\n", config["ORIGINAL_COPY"], config["ORIGINAL_COPY"] > outfile
  printf "Original Page: <a href=\"%s\">%s</a><br>\n", config["ORIGINAL_PAGE"], config["ORIGINAL_PAGE"] > outfile
  printf "Archived Copy: <a href=\"%s\">%s</a><br>\n", config["ARCHIVED_COPY"], config["ARCHIVED_COPY"] > outfile
  printf "Archived Page: <a href=\"%s\">%s</a><br>\n", config["ARCHIVED_PAGE"], config["ARCHIVED_PAGE"] > outfile
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
