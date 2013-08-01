require 'mechanize'

require 'nokogiri'
require 'open-uri'

cops_uel_url = 'http://www.cops.uel.br/vestibular/2009/RESULTADO/2A_FASE/7/GERAL.TXT'

#agent = Mechanize.new

#cops_uel = agent.get(cops_uel_url)

#puts cops_uel.css("a")

cops_uel_page = Nokogiri::HTML(open(cops_uel_url))

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

hash_uel = {}
current_key = "snk"

vet.each_with_index do |x, index|
        if x[0] != " " && x.length > 5
                current_key = vet[index]
                hash_uel[current_key] = []
        end
        if x.length > 10 
                if x != current_key
                        hash_uel[current_key] << x.lstrip
                end
        end
end

#puts hash_uel
#
#hash_uel.each do |key, value|
#        puts "----------------------------------------------"
#        puts "#{key}"
#        value.each do |i|
#                puts "=> #{i}"
#        end
#        puts "----------------------------------------------"
#end

