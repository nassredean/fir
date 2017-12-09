# frozen_string_literal: true
# encoding: UTF-8

require 'minitest/autorun'
require_relative '../lib/fir/indent'

describe Fir::Indent do
  describe 'class statement' do
    it 'indents a single nested class statement' do
      indent = indent_helper(
        <<~CODE
          class Cow
            def cow
              puts "moo"
            end
          end
        CODE
      )
      indent.indents.must_equal([0, 1, 2, 1, 0, 0])
      indent.executable?.must_equal(true)
    end

    it 'indents a doubly nested class statement' do
      indent = indent_helper(
        <<~CODE
          class Animal
            class Cow
              def say
                puts "moo"
              end
            end
          end
        CODE
      )
      indent.indents.must_equal([0, 1, 2, 3, 2, 1, 0, 0])
      indent.executable?.must_equal(true)
    end
  end

  describe 'module statement' do
    it 'indents a single nested module statement' do
      indent = indent_helper(
        <<~CODE
          module Cow
            def cow
              puts "moo"
            end
          end
        CODE
      )
      indent.indents.must_equal([0, 1, 2, 1, 0, 0])
      indent.executable?.must_equal(true)
    end

    it 'indents a doubly nested module statement' do
      indent = indent_helper(
        <<~CODE
          module Animal
            module Cow
              def say
                puts "moo"
              end
            end
          end
        CODE
      )
      indent.indents.must_equal([0, 1, 2, 3, 2, 1, 0, 0])
      indent.executable?.must_equal(true)
    end
  end

  describe 'def statement' do
    it 'indents a single line def statement' do
      indent = indent_helper(
        <<~CODE
          def cow(y)
            puts "moo"
          end
        CODE
      )
      indent.indents.must_equal([0, 1, 0, 0])
      indent.executable?.must_equal(true)
    end

    it 'indents a double line def statement' do
      indent = indent_helper(
        <<~CODE
          def cow(y)
            x="cow"
            puts x
          end
        CODE
      )
      indent.indents.must_equal([0, 1, 1, 0, 0])
      indent.executable?.must_equal(true)
    end

    it 'indents a nested def statement' do
      Fir::Indent
      indent = indent_helper(
        <<~CODE
          def animal(y)
            def dog
              puts x
            end
          end
        CODE
      )
      indent.indents.must_equal([0, 1, 2, 1, 0, 0])
      indent.executable?.must_equal(true)
    end
  end

  describe 'single line token with optional do' do
    %w[for while until].each do |token|
      describe "#{token} statement" do
        it 'indents correctly' do
          indent = Fir::Indent.new(["#{token} x == 1 do", '']).generate
          indent.indents.must_equal([0, 1])
          indent.executable?.must_equal(false)
        end

        it 'indents correctly' do
          indent = Fir::Indent.new(["#{token} x == 1 do", 'puts "cow"']).generate
          indent.indents.must_equal([0, 1])
          indent.executable?.must_equal(false)
        end

        it 'indents correctly' do
          indent = Fir::Indent.new(["#{token} x == 1 do", 'end', '']).generate
          indent.indents.must_equal([0, 0, 0])
          indent.executable?.must_equal(true)
        end

        it 'indents correctly' do
          indent = Fir::Indent.new(["#{token} x == 1 do", 'puts "cow"', 'end', '']).generate
          indent.indents.must_equal([0, 1, 0, 0])
          indent.executable?.must_equal(true)
        end

        it 'indents correctly' do
          indent = Fir::Indent.new(["#{token} x == 1 do", 'puts "cow"', 'puts "cow"', 'end', '']).generate
          indent.indents.must_equal([0, 1, 1, 0, 0])
          indent.executable?.must_equal(true)
        end

        it 'indents correctly' do
          indent = Fir::Indent.new(["#{token} x == 1", '']).generate
          indent.indents.must_equal([0, 1])
          indent.executable?.must_equal(false)
        end

        it 'indents correctly' do
          indent = Fir::Indent.new(["#{token} x == 1", 'puts "cow"']).generate
          indent.indents.must_equal([0, 1])
          indent.executable?.must_equal(false)
        end

        it 'indents correctly' do
          indent = Fir::Indent.new(["#{token} x == 1", 'end', '']).generate
          indent.indents.must_equal([0, 0, 0])
          indent.executable?.must_equal(true)
        end

        it 'indents correctly' do
          indent = Fir::Indent.new(["#{token} x == 1", 'puts "cow"', 'end', '']).generate
          indent.indents.must_equal([0, 1, 0, 0])
          indent.executable?.must_equal(true)
        end

        it 'indents correctly' do
          indent = Fir::Indent.new(["#{token} x == 1", 'puts "cow"', 'puts "cow"', 'end', '']).generate
          indent.indents.must_equal([0, 1, 1, 0, 0])
          indent.executable?.must_equal(true)
        end

        it 'indents correctly' do
          indent = Fir::Indent.new(["puts 'cow' #{token} true", '']).generate
          indent.indents.must_equal([0, 0])
          indent.executable?.must_equal(true)
        end

        it 'indents correctly' do
          indent = Fir::Indent.new(["puts 'cow' #{token} true", '']).generate
          indent.indents.must_equal([0, 0])
          indent.executable?.must_equal(true)
        end

        it 'indent correctly' do
          indent = indent_helper(
            <<~CODE
              #{token} x == 1
                #{token} true do
                  #{token} false
                    puts 'dog' #{token} true
                  end
                end
              end
            CODE
          )
          indent.indents.must_equal([0, 1, 2, 3, 2, 1, 0, 0])
          indent.executable?.must_equal(true)
        end
      end
    end
  end

  describe 'unmatched do token' do
    it 'indents' do
      indent = indent_helper(
        <<~CODE
          a.each do |x|
            puts x
            puts "hello"
          end
        CODE
      )
      indent.indents.must_equal([0, 1, 1, 0, 0])
      indent.executable?.must_equal(true)
    end

    it 'indents' do
      indent = indent_helper(
        <<~CODE
          while true do
            a = [1, 2, 3]
            a.each do |x|
              puts x
              puts "hello"
            end
          end
        CODE
      )
      indent.indents.must_equal([0, 1, 1, 2, 2, 1, 0, 0])
      indent.executable?.must_equal(true)
    end
  end

  describe 'if statement' do
    it 'indents' do
      indent = indent_helper(
        <<~CODE
          if true
            puts x
            puts "hello"
          end
        CODE
      )
      indent.indents.must_equal([0, 1, 1, 0, 0])
      indent.executable?.must_equal(true)
    end

    it 'indents' do
      indent = indent_helper(
        <<~CODE
          if true
            puts x
          else
            puts "hello"
          end
        CODE
      )
      indent.indents.must_equal([0, 1, 0, 1, 0, 0])
      indent.executable?.must_equal(true)
    end

    it 'indents' do
      indent = indent_helper(
        <<~CODE
          if true
            puts x
          elsif
            puts "hello"
          end
        CODE
      )
      indent.indents.must_equal([0, 1, 0, 1, 0, 0])
      indent.executable?.must_equal(true)
    end

    it 'indents' do
      indent = indent_helper(
        <<~CODE
          if true
            puts x
          elsif
            puts "hello"
          else
            puts "hello"
          end
        CODE
      )
      indent.indents.must_equal([0, 1, 0, 1, 0, 1, 0, 0])
      indent.executable?.must_equal(true)
    end

    it 'indents' do
      indent = indent_helper(
        <<~CODE
          if true
            puts x
            if true
              puts x
            else
              puts x
            end
          end
        CODE
      )
      indent.indents.must_equal([0, 1, 1, 2, 1, 2, 1, 0, 0])
      indent.executable?.must_equal(true)
    end

    it 'indents' do
      indent = indent_helper(
        <<~CODE
          if true
            puts x
            if true
              puts x
            else
              if false
                puts x
              elsif
                puts x
              end
            end
          end
        CODE
      )
      indent.indents.must_equal([0, 1, 1, 2, 1, 2, 3, 2, 3, 2, 1, 0, 0])
      indent.executable?.must_equal(true)
    end
  end

  describe 'case statement' do
    it 'indents' do
      indent = indent_helper(
        <<~CODE
          case grade
          when "A"
            puts 'Well done!'
          when "B"
            puts 'Try harder!'
          when "C"
            puts 'You need help!!!'
          else
            puts "You just making it up!"
          end
        CODE
      )
      indent.indents.must_equal([0, 0, 1, 0, 1, 0, 1, 0, 1, 0, 0])
      indent.executable?.must_equal(true)
    end
  end

  describe 'begin/rescue/ensure' do
    it 'indents' do
      indent = indent_helper(
        <<~CODE
          begin
            # something which might raise an exception
          rescue SomeExceptionClass => some_variable
            # code that deals with some exception
          rescue SomeOtherException => some_other_variable
            # code that deals with some other exception
          else
            # code that runs only if *no* exception was raised
          ensure
            # ensure that this code always runs, no matter what
            # does not change the final value of the block
          end
        CODE
      )
      indent.indents.must_equal([0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 1, 0, 0])
      indent.executable?.must_equal(true)
    end

    it 'indents' do
      indent = indent_helper(
        <<~CODE
          def foo
            # ...
          rescue
            # ...
          end
        CODE
      )
      indent.indents.must_equal([0, 1, 0, 1, 0, 0])
      indent.executable?.must_equal(true)
    end

    it 'indents' do
      indent = indent_helper(
        <<~CODE
          def foo
            # ...
          ensure
            # ...
          end
        CODE
      )
      indent.indents.must_equal([0, 1, 0, 1, 0, 0])
      indent.executable?.must_equal(true)
    end
  end

  describe 'strings' do
    it 'indents' do
      indent = indent_helper(
        <<~CODE
          '
          '
        CODE
      )
      indent.indents.must_equal([0, 0, 0])
      indent.executable?.must_equal(true)
    end

    it 'indents' do
      indent = indent_helper(
        <<~CODE
          "
          "
        CODE
      )
      indent.indents.must_equal([0, 0, 0])
      indent.executable?.must_equal(true)
    end

    it 'indents' do
      indent = indent_helper(
        <<~CODE
          "
          def cow
          puts 'dog'
          end
          "
        CODE
      )
      indent.indents.must_equal([0, 0, 0, 0, 0, 0])
      indent.executable?.must_equal(true)
    end

    it 'indents' do
      indent = indent_helper(
        <<~CODE
          def cow
            puts 'dog
            '
          end
        CODE
      )
      indent.indents.must_equal([0, 1, 1, 0, 0])
      indent.executable?.must_equal(true)
    end
  end

  describe 'escaped strings' do
    it 'indents' do
      indent = indent_helper(
        <<~CODE
          def hello
            "Hello \"world!"
            "hello"
          end
        CODE
      )
      indent.indents.must_equal([0, 1, 1, 0, 0])
      indent.executable?.must_equal(true)
    end

    it 'indents' do
      indent = indent_helper(
        <<~CODE
          def hello
            "Hello \" hello "
            "hello"
          end
        CODE
      )
      indent.indents.must_equal([0, 1, 1, 0, 0])
      indent.executable?.must_equal(true)
    end

    it 'indents' do
      indent = indent_helper(
        <<~CODE
          def hello
            "Hello \"
            hello"
            "hello"
          end
        CODE
      )
      indent.indents.must_equal([0, 1, 1, 1, 0, 0])
      indent.executable?.must_equal(true)
    end

    it 'indents' do
      indent = indent_helper(
        <<~CODE
          def hello
            "Hello \\"
            end
            "
          end
        CODE
      )
      indent.indents.must_equal([0, 1, 1, 1, 0, 0])
      indent.executable?.must_equal(true)
    end
  end

  describe 'arrays' do
    it 'indents' do
      indent = indent_helper(
        <<~CODE
          def cow
            [ 1, 2, 3 ]
            puts 'hello'
          end
        CODE
      )
      indent.indents.must_equal([0, 1, 1, 0, 0])
      indent.executable?.must_equal(true)
    end

    it 'indents' do
      indent = indent_helper(
        <<~CODE
          def cow
            [ 1,
              2,
              3 ]
            puts 'hello'
          end
        CODE
      )
      indent.indents.must_equal([0, 1, 2, 1, 1, 0, 0])
      indent.executable?.must_equal(true)
    end

    it 'indents' do
      indent = indent_helper(
        <<~CODE
          def cow
            [ 1,
              2,
            3]
            puts 'hello'
          end
        CODE
      )
      indent.indents.must_equal([0, 1, 2, 1, 1, 0, 0])
      indent.executable?.must_equal(true)
    end

    it 'indents' do
      indent = indent_helper(
        <<~CODE
          def cow
            [ 1,
              2,
              3
            ]
            puts 'hello'
          end
        CODE
      )
      indent.indents.must_equal([0, 1, 2, 2, 1, 1, 0, 0])
      indent.executable?.must_equal(true)
    end

    it 'indents' do
      indent = indent_helper(
        <<~CODE
          def cow
            [1,
              2,
              3
            ]
            puts 'hello'
          end
        CODE
      )
      indent.indents.must_equal([0, 1, 2, 2, 1, 1, 0, 0])
      indent.executable?.must_equal(true)
    end

    it 'indents' do
      indent = indent_helper(
        <<~CODE
          def cow
            [
              1,
              2,
              3
            ]
            puts 'hello'
          end
        CODE
      )
      indent.indents.must_equal([0, 1, 2, 2, 2, 1, 1, 0, 0])
      indent.executable?.must_equal(true)
    end

    it 'indents' do
      indent = indent_helper(
        <<~CODE
          def cow
            [
              [
                [
                  1,
                  2,
                  3
                ]
              ]
            ]
            puts 'hello'
          end
        CODE
      )
      indent.indents.must_equal([0, 1, 2, 3, 4, 4, 4, 3, 2, 1, 1, 0, 0])
      indent.executable?.must_equal(true)
    end
  end

  describe 'parentheses' do
    it 'indents' do
      indent = indent_helper(
        <<~CODE
          { 1: 'true', 2: 'true' }
        CODE
      )
      indent.indents.must_equal([0, 0])
      indent.executable?.must_equal(true)
    end

    it 'indents' do
      indent = indent_helper(
        <<~CODE
          def cow
            {
              {
                {
                  1: 'cow'
                  2: 'true'
                  3: 'for'
                }
              }
            }
            puts 'hello'
          end
        CODE
      )
      indent.indents.must_equal([0, 1, 2, 3, 4, 4, 4, 3, 2, 1, 1, 0, 0])
      indent.executable?.must_equal(true)
    end
  end

  describe 'regular heredocs' do
    it 'indents' do
      indent = indent_helper(
        <<~CODE
          def warning_message
            <<-HEREDOC
            HEREDOC
          end
        CODE
      )
      indent.indents.must_equal([0, 1, 1, 0, 0])
      indent.executable?.must_equal(true)
    end

    it 'indents' do
      indent = indent_helper(
        <<~CODE
          def warning_message
            <<-HEREDOC
              Subscription expiring soon!
              Your free trial will expire in 5 days.
              Please update your billing information.
            HEREDOC
          end
        CODE
      )
      indent.indents.must_equal([0, 1, 2, 2, 2, 1, 0, 0])
      indent.executable?.must_equal(true)
    end

    it 'indents' do
      indent = indent_helper(
        <<~CODE
          def code
            <<-HEREDOC
              def cow
              puts 'dog'
              end
            HEREDOC
          end
        CODE
      )
      indent.indents.must_equal([0, 1, 2, 2, 2, 1, 0, 0])
      indent.executable?.must_equal(true)
    end

    it 'indents' do
      indent = indent_helper(
        <<~CODE
          def warning_message
            <<-HEREDOC
              "
              "
              end
            HEREDOC
          end
        CODE
      )
      indent.indents.must_equal([0, 1, 2, 2, 2, 1, 0, 0])
      indent.executable?.must_equal(true)
    end
  end

  describe 'squiggly heredocs' do
    it 'indents' do
      indent = indent_helper(
        <<~CODE
          def warning_message
            <<~HEREDOC
            HEREDOC
          end
        CODE
      )
      indent.indents.must_equal([0, 1, 1, 0, 0])
      indent.executable?.must_equal(true)
    end

    it 'indents' do
      indent = indent_helper(
        <<~CODE
          def warning_message
            <<~HEREDOC
              Subscription expiring soon!
              Your free trial will expire in 5 days.
              Please update your billing information.
            HEREDOC
          end
        CODE
      )
      indent.indents.must_equal([0, 1, 2, 2, 2, 1, 0, 0])
      indent.executable?.must_equal(true)
    end

    it 'indents' do
      indent = indent_helper(
        <<~CODE
          def code
            <<~HEREDOC
              def cow
              puts 'dog'
              end
            HEREDOC
          end
        CODE
      )
      indent.indents.must_equal([0, 1, 2, 2, 2, 1, 0, 0])
      indent.executable?.must_equal(true)
    end

    it 'indents' do
      indent = indent_helper(
        <<~CODE
          def warning_message
            <<~HEREDOC
              "
              "
              end
            HEREDOC
          end
        CODE
      )
      indent.indents.must_equal([0, 1, 2, 2, 2, 1, 0, 0])
      indent.executable?.must_equal(true)
    end
  end
end

def indent_helper(code)
  Fir::Indent.new(code.split("\n").push('')).generate
end
