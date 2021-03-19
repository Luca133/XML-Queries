<html>
    <body>
        <table border = "1">
            <tr>
                <th>Target</th> 
                <th>Successor</th>
            </tr>
            {
            (: For each word in the collection of xml files, if a word equals the target word, return the target word and its successor word :)
            
            for $w in collection("?select=*.xml")//w (: Collects all .xml files in current directory :)
            let $targetWord := normalize-space(lower-case($w)), (: Normalize the target word to lower case, ensures all instances of it are caught :)
                $successorWord := normalize-space(lower-case($w/following-sibling::w[1])) (: Set the successor word to the word after the target word.
                                                                                             Also normalize to lower case to ensure all instances are caught :)
            where $targetWord = 'has' (: Set target word to "has":)
            return (: Return the output :)
            <tr>
                <th>{$targetWord}</th>
                <th>{$successorWord}</th>
            </tr>
            }
        </table>
    </body>
</html>