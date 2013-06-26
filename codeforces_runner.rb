#!/usr/bin/env ruby

require 'open-uri'
require 'colorize'

# USER SETTINGS
# where to save samples
DATADIR = '/home/delta/codeforces'
# where you coding
WORKSPACE = '/home/delta/codeforces'

# CONSANTS DEFINATION
# testcase spliter when parsing
SPLITER = /<br \/>/
# title, input, output match pattern in html
TITLEP = /<div class="title">(.*?)<\/div>/
INP = /<div class="input"><div class="title">Input<\/div><pre>(.*?)<\/pre><\/div>/
OUTP = /<div class="output"><div class="title">Output<\/div><pre>(.*?)<\/pre><\/div>/	
# contest url prefix
URLPREFIX = 'http://codeforces.com/contest'
# basename
BASENAME = File.basename($0).to_s

def help
	puts <<-EOF.gsub(/^\s*\|/, '')
		|Usage: #{BASENAME} [OPTION] CONTEST_ID
		|A simple tool to run codeforces samples
		|
		|  contest_id       start contest
		|  -r contest_id    rerun contest 
		|  -d contest_id    only download testcases
		|  -h               display this help
	EOF
end

# save data to file
def save(filename, data)
	f = File.open(filename, 'w')
	f.puts(data)
	f.close
end

# parse contest problem page, get input, output
def parse_problem(url, id, cwd)
	html_doc = open(url).read	
	title = html_doc.scan(TITLEP)[0][0]
	input = html_doc.scan(INP).map { |input| input.join.gsub(SPLITER, "\n") }
	output = html_doc.scan(OUTP).map { |output| output.join.gsub(SPLITER, "\n") }
	cases = input.size		

	cases.times do |i|
		save(cwd + '/' + id + "_" + i.to_s + ".in", input[i])
		save(cwd + '/' + id + "_" + i.to_s + ".out", output[i])
	end

	puts "Problem '#{title}' is succesfully downloaded"
end

def download_problems(contest_id, redownload = false)
	url = [URLPREFIX, contest_id, "problem"].join('/')
	savedir = [DATADIR, contest_id].join('/')
	system("rm -rf #{savedir}") if redownload && Dir.exist?(savedir)
	return if Dir.exist?(savedir)
	Dir.mkdir(savedir)
	[*'A'..'E'].each do |problem_id| 
		Dir.mkdir([savedir, problem_id].join('/'))
		parse_problem([url, problem_id].join('/'), problem_id, [savedir, problem_id].join('/'))
	end
	puts "All the problems are succesfully downloaded".green
end

def have_fun(contest_id)
	download_problems(contest_id)	
end

if ARGV.size == 0
	puts "There got to be at least one argument\nType '#{BASENAME} -h' for more help"
elsif ARGV[0] == '-h'
	help
elsif ARGV[0] == '-d'
	download_problems(ARGV[1], true)
else
	have_fun(ARGV[1])
end
