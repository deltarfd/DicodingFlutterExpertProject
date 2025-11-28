import re
import os

def check_coverage():
    lcov_path = 'coverage/lcov.info'
    if not os.path.exists(lcov_path):
        print(f"Error: {lcov_path} not found")
        return

    total_lines = 0
    total_hit = 0
    
    file_lines = 0
    file_hit = 0
    uncovered_lines = []
    current_file = ""
    
    with open(lcov_path, 'r') as f:
        for line in f:
            if line.startswith('SF:'):
                current_file = line.strip()[3:]
            
            match = re.match(r'^DA:(\d+),(\d+)', line)
            if match:
                line_num = int(match.group(1))
                hits = int(match.group(2))
                
                total_lines += 1
                if hits > 0:
                    total_hit += 1
                
                if 'tv_detail_page.dart' in current_file:
                    file_lines += 1
                    if hits > 0:
                        file_hit += 1
                    else:
                        uncovered_lines.append(line_num)

    if total_lines > 0:
        print(f"Total Coverage: {round(total_hit/total_lines*100, 2)}% ({total_hit}/{total_lines})")
    else:
        print("Total Coverage: 0%")

    if file_lines > 0:
        print(f"TvDetailPage Coverage: {round(file_hit/file_lines*100, 2)}% ({file_hit}/{file_lines})")
        print(f"Uncovered lines in TvDetailPage: {uncovered_lines}")
    else:
        print("TvDetailPage not found in coverage report")

if __name__ == "__main__":
    check_coverage()
