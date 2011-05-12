module CLI
  class Quizzer
    attr_reader :questionaire

    def initialize(questionaire)
      @questionaire = questionaire
    end

    def quiz
      results = []
      questions = questionaire.questions.sort_by { rand }

      begin
        questions.each_with_index do |question, i|
          q = ask(question, i+1, questions.size)
          results << [question[:id], q]
        end
      rescue EOFError
        # tolerate Ctrl-D, skips the rest of the quiz
      end

      questionaire.grade(results)
    end

    private
      def ask(question, i, n)
        width = "#{n}/#{n}. ".size
        padding = " " * width

        print "#{i}/#{n}. ".rjust(width) + "Q: #{question[:question]}"
        readline

        puts padding + "A: #{question[:answer]}"

        while true
          print padding + "? "
          answer = readline.chomp

          if answer =~ /\A[0-5]\Z/
            puts
            return answer.to_i
          end
        end
      end
  end
end
