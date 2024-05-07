# File: update_robots.rb
require 'fileutils'

# Path to the public directory where robots.txt is located
public_dir = File.join(Rails.root, 'public')
robots_file_path = File.join(public_dir, 'robots.txt')

# New content for the robots.txt - more information in http://www.robotstxt.org/robotstxt.html
new_content = <<~ROBOTS
  User-agent: *
  Disallow: /
ROBOTS

# Write the new content to robots.txt
File.write(robots_file_path, new_content)

puts "robots.txt has been updated."
