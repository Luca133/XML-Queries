<html>
    <body>
        <table border = "1">
            <tr>
                <th>Target</th>
                <th>Successor</th>
                <th>Frequency</th>
            </tr>
            {
            (: For each word in the collection of xml files, if a word equals the target word, return the target word,
               its successor word, and a count of the distinct successor words :)
               
            let $targetWords := collection("?select=*.xml")//w[lower-case(normalize-space()) = "has"], (: Extract the target words from the collection,
                                                                                                          normalizing for lower case:)
                $successorWords := $targetWords/lower-case(normalize-space(following-sibling::w[1])) (: Extract the successor words from the collection,
                                                                                                        normalizing for lower case:)
            for $distinctWord in distinct-values($successorWords) (: For each distinct successor word :)
            let $frequency := count($successorWords[.=$distinctWord]) (: Count number of occurences of distinct successor word :)
            order by $frequency descending (: Order output in descending order of frequency :)
            return (: Return the output :)
            <tr>
                <td> {$targetWords[1]} </td>
                <td> {$distinctWord} </td>
                <td> {$frequency} </td>
            </tr>
            }
        </table>
    </body>
</html>