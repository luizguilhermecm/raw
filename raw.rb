require 'mechanize'
require 'nokogiri'
require 'open-uri'
require "koala"

@hash_uel = {}

#cops_uel_url = 'http://www.cops.uel.br/vestibular/2009/RESULTADO/2A_FASE/7/GERAL.TXT'

def FacebookGraph
        @graph = Koala::Facebook::API.new("CAABZCOeqexSEBAMVcbsqtnjKvkhUC1Thacza8lMoyl20l1FZBdtgs85PdyPBTFLQuUD9FZA5WSXyGM9YWYeHCNy1MX7BNZAHrwYzfTsLKt4CpFvgZBMN1Vy3CSa9Udh9wTpWRjkj70HW0mIm2uuWzXEbcCURNJ3MZD")
        @hash_uel.each do |key, value|
                puts "--------------------------------"
                puts "#{key}"
                value.each do |i|
                        puts "\t => #{i} => checking"
                        names = i.split(" ")
                        saved_index = -1
                        names.each_with_index do |nome, index|
                                puts "\t\t => #{nome}"
                                if nome.length < 3
                                        puts "\t\t\t => #{nome}"
                                        saved_index = index
                                elsif nome.length == 3 && nome == "DOS"
                                        saved_index = index
                                end
                        end
                        if saved_index >= 0
                                names.delete_at(saved_index)
                                puts "\t\t => #{names} => name changed"
                        end 

                        target = @graph.search(i, {:type => "user"})
                        target.each do |user|
                                url = 'https://www.facebook.com/' + user["id"].to_s
                                if SearchIntoProfile(url)
                                        puts "\t\t => #{i} => #{url}"
                                else 
                                        print " *"
                                end
                        end
                        puts "\n"
                        puts "\t\t --> permuting names"
                        for count in 1..names.size-1
                                puts "\t\t\t => #{names[0]} #{names[count]}"
                                searching = names[0] + names[count]

                                target = @graph.search(searching, {:type => "user"})
                                target.each do |user|
                                        url = 'https://www.facebook.com/' + user["id"].to_s
                                        if SearchIntoProfile(url)
                                                puts "\t\t => #{searching} => #{url}"
                                        else
                                                print " *"
                                        end
                                end
                        end
                puts "------"
                puts "------"
                end
        end
end

def SearchIntoProfile(url)
        fb = FacebookConnect()
        page = fb.get(url)
        nok = page.parser.to_s
        if nok[/Londrina/]
                return true
        else
                return false
        end
        return false
end

def FacebookConnect
        agent = Mechanize.new
        page = agent.get('https://www.facebook.com/wesleiguerra')
        google_form = page.form_with(:id => 'login_form')
        google_form.email = 'luizgui23@hotmail.com'
        google_form.pass = 'raw_stalk'
        page = agent.submit(google_form)
        return agent
end


def GetNames(page_url)

        cops_uel_page = Nokogiri::HTML(open(page_url))

        cops_uel_page.encoding = 'utf-8'

        cops_uel_text = cops_uel_page.text

        aux = cops_uel_text.gsub(/[^a-zA-Z\s\/]/,"")

        aux = aux.gsub(/NOME DO CANDIDATO/, "")
        aux = aux.gsub(/INSC/, "")
        aux = aux.gsub(/\r/, "")

        aux = aux.squeeze(" ")
        vet = aux.split("\n")

        vet.each_with_index do |del, index|
                if del[/UNIVERSIDADE ESTADUAL DE LONDRINA/]
                        vet.delete_at(index)

                elsif del[/SELETIVOS/]
                        vet.delete_at(index)

                elsif del[/PROCESSO SELETIVO VESTIBULAR/]
                        vet.delete_at(index)
                        break;
                end
        end
        vet.delete_at(0)
        vet.delete_at(1)

        current_key = "snk"
        vet.each_with_index do |x, index|
                if x[0] != " " && x.length > 5
                        current_key = vet[index]
                        if @hash_uel.has_key?(x)
                        
                        else
                                @hash_uel[current_key] = []
                        end
                end

                if x.length > 10 
                        if x != current_key
                                @hash_uel[current_key] << x.lstrip
                        end
                end
        end
end

def PrintHash (hash_to_print)
        hash_to_print.each do |key, value|
                puts "----------------------------------------------"
                puts "#{key}"
                value.each do |i|
                        puts "=> #{i}"
                end
                puts "----------------------------------------------"
        end
end

def GetHashSize (aux)
        puts "keys => " + aux.size.to_s
        total = 0
        aux.each do |key, value|
#                puts "----------------------------------------------"
#                puts "key => " + key.to_s 
#                puts "----size => " + value.size.to_s
                total += value.size
        end
        puts "====================="
        puts total.to_s
        puts "====================="
end

def GetByYear (ano)

        url_base_ini = 'http://www.cops.uel.br/vestibular/'
        url_base_meio = '/RESULTADO/2A_FASE/'
        url_base_fim = '/GERAL.TXT'

        goal = url_base_ini + ano.to_s + url_base_meio

        for i in 1..20
                aux = goal + i.to_s + url_base_fim
                begin
                        page = Nokogiri::HTML(open(aux))
                        GetNames(aux)                
                rescue
                end
        end
end

#GetByYear(ARGV.first)
#GetHashSize(@hash_uel)
#PrintHash(@hash_uel)

#FacebookConnect()
GetByYear(2010)
FacebookGraph()


