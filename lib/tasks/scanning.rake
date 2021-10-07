require "English"
require "open3"

namespace :bundle do
  desc "Run bundle:audit with omniauth CVE ignored"
  task :audit do
    child_pid = fork {
      exec "bundle audit update && bundle audit check"
    }
    Process.wait(child_pid)
    status = $CHILD_STATUS.exitstatus
    exit status unless status == 0
  end
end

desc "Run brakeman with potential non-0 return code"
task :brakeman do
  # -z flag makes it return non-0 if there are any warnings
  # -q is quiet, which is on here because we don't want the output to be too large
  # when integrated into tests
  unless system("brakeman -z -q") # system is true if return is 0, false otherwise
    abort("Brakeman detected one or more code problems, please run it manually and inspect the output.")
  end
end

namespace :yarn do
  desc "Run yarn audit"
  task :audit do
    stdout, stderr, status = Open3.capture3("yarn audit --json")
    unless status.success?
      puts stderr
      parsed = JSON.parse("[#{stdout.lines.join(",")}]")
      puts JSON.pretty_generate(parsed)
      if /503 Service Unavailable/.match?(stderr)
        puts "Ignoring unavailable server"
      elsif all_issues_ignored?(parsed)
        puts "Ignoring known and accepted yarn audit results"
      else
        exit status.exitstatus
      end
    end
  end
end

def all_issues_ignored?(issues)
  summary = issues.find { |json| json["type"] == "auditSummary" }["data"]["vulnerabilities"]
  # immediately fail if more findings are discovered, even if they have the same advisory ID,
  # this helps to ensure that we fully evaluate the risk present
  return false unless (summary["moderate"] <= 11 && summary["high"] == 0 && summary["critical"] <= 4)
  advisory_ids = issues.select { |json| json["type"] == "auditAdvisory" }.map { |json| json["data"]["advisory"]["id"] }
  # 1002373 is a withdrawn critical CVE on lodash
  # 1002401 and 1002423 are moderate findings related to inefficient regexs that we are only using at build time
  advisory_ids.all? { |id| [1002401, 1002373, 1002423].include? id }
end


task default: "standard"
task default: "brakeman"
task default: "bundle:audit"
task default: "yarn:audit"
