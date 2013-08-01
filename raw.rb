
require 'nokogiri'
require 'open-uri'

@hash_uel = {}

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
                        @hash_uel[current_key] = []
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


cops_uel_url = 'http://www.cops.uel.br/vestibular/2009/RESULTADO/2A_FASE/7/GERAL.TXT'

GetNames(cops_uel_url)
PrintHash(@hash_uel)
