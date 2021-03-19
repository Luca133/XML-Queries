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
               its successor word, and the probability that each distinct successor word occurs after the target word :)
               
            let $targetWords := collection("?select=*.xml")//w[lower-case(normalize-space()) = "has"], (: Extract the target words from the collection,
                                                                                                          normalizing for lower case:)
                $successorWords := $targetWords/lower-case(normalize-space(following-sibling::w[1])) (: Extract the successor words from the collection,
                                                                                                        normalizing for lower case:)
            for $distinctWord in distinct-values($successorWords) (: For each distinct successor word :)
            let $numerator := count($successorWords[.=$distinctWord]), (: Count the number of times each word occurs as a successor to the taget word and store in numerator :)
                $denominator := count(collection("?select=*.xml")//w[lower-case(normalize-space()) = $distinctWord]), (: Count number of times a successor word 
                                                                                                                         occurs in all desired .xml files and store in denominator :)
                $probability := $numerator div $denominator (: Compute probability that a successor word occurs after the target word by dividing the total number
                                                               of times a word occurs as a successor word (numerator), by the total number of occurences of that word in the
                                                               collection (denonminator) :)
            order by $probability descending (: Order output in descending order of probability :)
            return (: Return the output :)
            <tr>
                <td> {$targetWords[1]} </td>
                <td> {$distinctWord} </td>
                <td> {$probability} </td>
            </tr>
            }
        </table>
    </body>
</html>