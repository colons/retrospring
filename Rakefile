# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)

Rails.application.load_tasks

namespace :justask do
  desc "Recount everything!"
  task recount: :environment do
    format = '%t (%c/%C) [%b>%i] %e'
    total = User.count
    progress = ProgressBar.create title: 'Processing users', format: format, starting_at: 0, total: total
    User.all.each do |user|
      begin
        answered = Answer.where(user: user).count
        asked = Question.where(user: user).where(author_is_anonymous: false).count
        commented = Comment.where(user: user).count
        smiled = Smile.where(user: user).count
        user.friend_count = user.friends.count
        user.follower_count = user.followers.count
        user.answered_count = answered
        user.asked_count = asked
        user.commented_count = commented
        user.smiled_count = smiled
        user.save!
      end
      progress.increment
    end

    total = Question.count
    progress = ProgressBar.create title: 'Processing questions', format: format, starting_at: 0, total: total
    Question.all.each do |question|
      begin
        answers = Answer.where(question: question).count
        question.answer_count = answers
        question.save!
      end
      progress.increment
    end

    total = Answer.count
    progress = ProgressBar.create title: 'Processing answers', format: format, starting_at: 0, total: total
    Answer.all.each do |answer|
      begin
        smiles = Smile.where(answer: answer).count
        comments = Comment.where(answer: answer).count
        answer.comment_count = comments
        answer.smile_count = smiles
        answer.save!
      end
      progress.increment
    end
  end

  desc "Gives admin status to an user."
  task :admin, [:screen_name] => :environment do |t, args|
    fail "screen name required" if args[:screen_name].nil?
    user = User.find_by_screen_name(args[:screen_name])
    fail "user #{args[:screen_name]} not found" if user.nil?
    user.admin = true
    user.save!
    puts "#{user.screen_name} is now an admin."
  end

  desc "Removes admin status from an user."
  task :deadmin, [:screen_name] => :environment do |t, args|
    fail "screen name required" if args[:screen_name].nil?
    user = User.find_by_screen_name(args[:screen_name])
    fail "user #{args[:screen_name]} not found" if user.nil?
    user.admin = false
    user.save!
    puts "#{user.screen_name} is no longer an admin."
  end

  desc "Gives moderator status to an user."
  task :mod, [:screen_name] => :environment do |t, args|
    fail "screen name required" if args[:screen_name].nil?
    user = User.find_by_screen_name(args[:screen_name])
    fail "user #{args[:screen_name]} not found" if user.nil?
    user.moderator = true
    user.save!
    puts "#{user.screen_name} is now an moderator."
  end

  desc "Removes moderator status from an user."
  task :demod, [:screen_name] => :environment do |t, args|
    fail "screen name required" if args[:screen_name].nil?
    user = User.find_by_screen_name(args[:screen_name])
    fail "user #{args[:screen_name]} not found" if user.nil?
    user.moderator = false
    user.save!
    puts "#{user.screen_name} is no longer an moderator."
  end

  desc "Hits an user with the banhammer."
  task :ban, [:screen_name] => :environment do |t, args|
    fail "screen name required" if args[:screen_name].nil?
    user = User.find_by_screen_name(args[:screen_name])
    fail "user #{args[:screen_name]} not found" if user.nil?
    user.banned = true
    user.save!
    puts "#{user.screen_name} got hit by\033[5m YE OLDE BANHAMMER\033[0m!!1!"
  end

  desc "Removes banned status from an user."
  task :unban, [:screen_name] => :environment do |t, args|
    fail "screen name required" if args[:screen_name].nil?
    user = User.find_by_screen_name(args[:screen_name])
    fail "user #{args[:screen_name]} not found" if user.nil?
    user.banned = false
    user.save!
    puts "#{user.screen_name} is no longer banned."
  end

  desc "Gives blogger status to an user."
  task :blog, [:screen_name] => :environment do |t, args|
    fail "screen name required" if args[:screen_name].nil?
    user = User.find_by_screen_name(args[:screen_name])
    fail "user #{args[:screen_name]} not found" if user.nil?
    user.blogger = true
    user.save!
    puts "#{user.screen_name} is now a blogger."
  end

  desc "Removes blogger status from an user."
  task :unblog, [:screen_name] => :environment do |t, args|
    fail "screen name required" if args[:screen_name].nil?
    user = User.find_by_screen_name(args[:screen_name])
    fail "user #{args[:screen_name]} not found" if user.nil?
    user.blogger = false
    user.save!
    puts "#{user.screen_name} is no longer a blogger."
  end

  desc "Gives supporter status to an user."
  task :sup, [:screen_name] => :environment do |t, args|
    fail "screen name required" if args[:screen_name].nil?
    user = User.find_by_screen_name(args[:screen_name])
    fail "user #{args[:screen_name]} not found" if user.nil?
    user.supporter = true
    user.save!
    puts "#{user.screen_name} is now an supporter."
  end

  desc "Removes supporter status from an user."
  task :desup, [:screen_name] => :environment do |t, args|
    fail "screen name required" if args[:screen_name].nil?
    user = User.find_by_screen_name(args[:screen_name])
    fail "user #{args[:screen_name]} not found" if user.nil?
    user.supporter = false
    user.save!
    puts "#{user.screen_name} is no longer an supporter."
  end

  desc "Lists all users."
  task lusers: :environment do
    User.all.each do |u|
      puts "#{sprintf "%3d", u.id}. #{u.screen_name}"
    end
  end

  desc "Fixes the notifications"
  task fix_notifications: :environment do
    format = '%t (%c/%C) [%b>%i] %e'
    total = Notification.count
    progress = ProgressBar.create title: 'Processing notifications', format: format, starting_at: 0, total: total
    destroyed_count = 0

    Notification.all.each do |n|
      if n.target.nil?
        n.destroy
        destroyed_count += 1
      end
      progress.increment
    end

    puts "Purged #{destroyed_count} dead notifications."
  end

  desc "Fixes everything else"
  task fix_db: :environment do
    format = '%t (%c/%C) [%b>%i] %e'
    destroyed_count = {
        inbox: 0,
        question: 0,
        answer: 0,
        smile: 0,
        comment: 0
    }

    total = Inbox.count
    progress = ProgressBar.create title: 'Processing inboxes', format: format, starting_at: 0, total: total
    Inbox.all.each do |n|
      if n.question.nil?
        n.destroy
        destroyed_count[:inbox] += 1
      end
      progress.increment
    end

    total = Question.count
    progress = ProgressBar.create title: 'Processing questions', format: format, starting_at: 0, total: total
    Question.all.each do |q|
      if q.user.nil?
        q.user_id = nil
        q.author_is_anonymous = true
        destroyed_count[:question] += 1
      end
      progress.increment
    end

    total = Answer.count
    progress = ProgressBar.create title: 'Processing answers', format: format, starting_at: 0, total: total
    Answer.all.each do |a|
      if a.user.nil? or a.question.nil?
        a.destroy
        destroyed_count[:answer] += 1
      end
      progress.increment
    end

    total = Comment.count
    progress = ProgressBar.create title: 'Processing comments', format: format, starting_at: 0, total: total
    Comment.all.each do |c|
      if c.user.nil? or c.answer.nil?
        c.destroy
        destroyed_count[:comment] += 1
      end
      progress.increment
    end

    puts "Purged #{destroyed_count[:inbox]} dead inbox entries."
    puts "Marked #{destroyed_count[:question]} questions as anonymous."
    puts "Purged #{destroyed_count[:answer]} dead answers."
    puts "Purged #{destroyed_count[:answer]} dead comments."
  end

  desc "Prints lonely people."
  task loners: :environment do
    people = {}
    Question.all.each do |q|
      if q.author_is_anonymous and q.author_name != 'justask'
        q.answers.each do |a|
          if q.user == a.user
            people[q.user.screen_name] ||= 0
            people[q.user.screen_name] += 1
            puts "#{q.user.screen_name} -- answer id #{a.id}"
          end
        end
      end
    end

    max = 0
    res = []
    people.each { |k, v| max = v if v > max }
    people.each { |k, v| res << k if v == max }
    if res.length == 0
      puts "No one?  I hope you're just on the development session."
    else
      puts res.length == 1 ? "And the winner is..." : "And the winners are..."
      print "\033[5;31m"
      res.each { |name| puts " - #{name}" }
      print "\033[0m"
    end
  end

  desc "Export data for an user"
  task :export, [:email] => :environment do |t, args|
    require 'json'
    require 'yaml'
    return if args[:email].nil?
    obj = {}
    format = '%t (%c/%C) [%b>%i] %e'
    u = User.where("LOWER(email) = ?", args[:email].downcase).first!
    export_dirname = "export_#{u.screen_name}_#{Time.now.to_i}"
    export_filename = u.screen_name

    %i(id screen_name display_name created_at sign_in_count last_sign_in_at friend_count follower_count asked_count answered_count commented_count smiled_count motivation_header bio website location moderator admin supporter banned blogger).each do |f|
      obj[f] = u.send f
    end

    total = u.questions.count
    progress = ProgressBar.create title: 'Processing questions', format: format, starting_at: 0, total: total
    obj[:questions] = []
    u.questions.each do |q|
      qobj = {}
      %i(id content author_is_anonymous created_at answer_count).each do |f|
        qobj[f] = q.send f
      end
      obj[:questions] << qobj
      progress.increment
    end

    total = u.answers.count
    progress = ProgressBar.create title: 'Processing answers', format: format, starting_at: 0, total: total
    obj[:answers] = []
    u.answers.each do |a|
      aobj = {}
      %i(id content comment_count smile_count created_at).each do |f|
        aobj[f] = a.send f
      end
      aobj[:question] = {}
      %i(id content author_is_anonymous created_at answer_count).each do |f|
        aobj[:question][f] = a.question.send f
      end
      aobj[:question][:user] = a.question.user.screen_name unless a.question.author_is_anonymous
      aobj[:comments] = []
      a.comments.each do |c|
        cobj = {}
        %i(id content created_at).each do |f|
          cobj[f] = c.send f
        end
        cobj[:user] = c.user.screen_name
        aobj[:comments] << cobj
      end
      obj[:answers] << aobj
      progress.increment
    end

    total = u.comments.count
    progress = ProgressBar.create title: 'Processing comments', format: format, starting_at: 0, total: total
    obj[:comments] = []
    u.comments.each do |c|
      cobj = {}
      %i(id content created_at).each do |f|
        cobj[f] = c.send f
      end
      cobj[:answer] = {}
      %i(id content comment_count smile_count created_at).each do |f|
        cobj[:answer][f] = c.answer.send f
      end
      cobj[:answer][:question] = {}
      %i(id content author_is_anonymous created_at answer_count).each do |f|
        cobj[:answer][:question][f] = c.answer.question.send f
      end
      cobj[:answer][:question][:user] = c.answer.question.user.screen_name unless c.answer.question.author_is_anonymous
      obj[:comments] << cobj
      progress.increment
    end

    total = u.smiles.count
    progress = ProgressBar.create title: 'Processing smiles', format: format, starting_at: 0, total: total
    obj[:smiles] = []
    u.smiles.each do |s|
      sobj = {}
      %i(id created_at).each do |f|
        sobj[f] = s.send f
      end

      sobj[:answer] = {}
      %i(id content comment_count smile_count created_at).each do |f|
        sobj[:answer][f] = s.answer.send f
      end
      sobj[:answer][:question] = {}
      %i(id content author_is_anonymous created_at answer_count).each do |f|
        sobj[:answer][:question][f] = s.answer.question.send f
      end
      sobj[:answer][:question][:user] = s.answer.question.user.screen_name unless s.answer.question.author_is_anonymous

      obj[:smiles] << sobj
      progress.increment
    end

    `mkdir -p /usr/home/justask/justask/public/export`
    `mkdir -p /tmp/rs_export/#{export_dirname}/picture`
    if u.profile_picture
      %i(large medium small original).each do |s|
        `cp #{u.profile_picture.path s} /tmp/rs_export/#{export_dirname}/picture/#{s}_#{File.basename u.profile_picture.path}`
      end
    end
    File.open "/tmp/rs_export/#{export_dirname}/#{export_filename}.json", 'w' do |f|
      f.puts obj.to_json
    end
    File.open "/tmp/rs_export/#{export_dirname}/#{export_filename}.yml", 'w' do |f|
      f.puts obj.to_yaml
    end
    `tar czvf public/export/#{export_dirname}.tar.gz -C /tmp/rs_export #{export_dirname}`
    puts "\033[1mhttps://retrospring.net/export/#{export_dirname}.tar.gz\033[0m"
  end
end
