local M = {}

-- cf https://iwsttty.hatenablog.com/entry/20110321/1300729749
local ROMAJI_WORD = vim.regex("^\\%(\\\\a\\)\\=\\zs\\(\\(\\(\\([bdfghjklmnpstrzwx]\\)\\4\\=\\)\\=y\\=\\([ei]\\|[aou]h\\=\\)\\)\\|\\%(ss\\=\\|dd\\=\\)\\=h[aiuo]\\|cc\\=h[aio]\\|tt\\=su\\|n\\|-\\)\\+$")

local global_opts = {
  cmigemo_exec_path = "cmigemo",
  migemo_dict_path = nil,
}

local function find_migemo_dict()
  for _, dir in ipairs({
    "/opt/homebrew/share",
    "/usr/share/cmigemo",
    "/usr/local/share/migemo",
    "/usr/share/migemo",
  }) do
    for _, path in ipairs({
      "/migemo/utf-8/migemo-dict",
      "/utf-8/migemo-dict",
      "/migemo-dict"
    }) do
      if vim.fn.filereadable(dir .. path) == 0 then
        return dir .. path
      end
    end
  end

  return nil
end

local function extract_romaji_word(str)
  local from, to = ROMAJI_WORD:match_str(str)

  if from == nil then return nil end
  return string.sub(str, from + 1, to)
end

local function generate_regex_from_romaji_word(word)
  return vim.fn.system({
    global_opts.cmigemo_exec_path,
    "-d", global_opts.migemo_dict_path,
    "-v",
    "-w", word
  })
end

local function substitute_romaji_word()
  local cmdline = vim.fn.getcmdline()
  local word = extract_romaji_word(cmdline)

  if word == nil then return end
  vim.fn.setcmdline(generate_regex_from_romaji_word(word))
end

function M.cr()
  local cmdtype = vim.fn.getcmdtype()

  if cmdtype == "/" or cmdtype == "?" then
    substitute_romaji_word()
  end

  vim.api.nvim_feedkeys(
    vim.api.nvim_replace_termcodes("<CR>", true, false, true),
    "n",
    false
  )
end

function M.setup(opts)
  global_opts = vim.tbl_extend("force", global_opts, opts)

  if vim.fn.executable(global_opts.cmigemo_exec_path) == 1 then
    global_opts.cmigemo_exec_path = vim.fn.exepath(global_opts.cmigemo_exec_path)
  else
    vim.api.nvim_err_writeln("cmigemo not found")
  end

  if global_opts.migemo_dict_path == nil or vim.fn.filereadable(global_opts.migemo_dict_path) == 0 then
    global_opts.migemo_dict_path = find_migemo_dict()
  end
  if global_opts.migemo_dict_path == nil then
    vim.api.nvim_err_writeln("migemo dictionary not found")
  end
end

return M
