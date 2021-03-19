<html>
    <body>
        <table border="1">
            <tr>
                <th>Target</th>
                <th>Successor</th>
                <th>Probabilty</th>
            </tr>
            {
            (: For each word in the collection of xml files, if a word equals the target word, return the target word,
               the top 20 successor words, and the probability that each successor word occurs after the target word :)
               
            let $targetWords := collection("?select=*.xml")//w[lower-case(normalize-space()) = "has"], (: Extract the target words from the collection,
                                                                                                          normalizing for lower case:)
                $successorWords := $targetWords/lower-case(normalize-space(following-sibling::w[1])), (: Extract the successor words from the collection,
                                                                                                        normalizing for lower case:)
                $distinctWords := distinct-values($successorWords), (: Extract the distinct successor words from the collection :)
                (: Make a container called $probabilityList:)
                $probabilityList :=
                     for $word at $i in $distinctWords (: For each word in the list of distinct successor words:)
                     let $numerator := count($successorWords[.=$word]), (: Count the number of times each word occurs as a successor to the taget word and store in numerator :)
                         $denominator := count(collection("?select=*.xml")//w[lower-case(normalize-space()) = $word]), (: Count number of times a successor word occurs in 
                                                                                                                          all desired .xml files and store in denominator :)
                         $probability := $numerator div $denominator (: Compute probability that a successor word occurs after the target word by dividing the total number
                                                                        of times a word occurs as a successor word (numerator), by the total number of occurences of that
                                                                        word in the collection (denonminator) :)
                     order by $probability descending (: Order output in descending order of probability :)
                     
                     (: Store the successor words and their probabilites in a container to preserve connection :)
                     return <container>
                                <probability>{$probability}</probability>
                                <word>{$word}</word>
                            </container>
             (: Return and print the target word and the top 20 successor words and their probabilites :)        
             for $probability at $i in subsequence($probabilityList,1,20)
             return
                <tr>
                    <td> {$targetWords[1]/text()} </td>
                    <td> {$probabilityList[$i]/word/text()} </td>
                    <td> {$probabilityList[$i]/probability/text()} </td>
                </tr>
            }
        </table>
    </body>
</html>