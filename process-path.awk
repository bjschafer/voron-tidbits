{
    link = "=HYPERLINK(CONCATENATE(\"https://github.com/VoronDesign/Voron-Trident/blob/VTr1/STLs/\", INDIRECT(CONCAT(\"F\", ROW()))), \"Link\")"
    gsub(/"/, "\"\"", link)
    # find which field number contains the part file
    for (i=1; i<=NF; i++) {
        if ($i ~ /\.stl$/) {
            fileField = i
        }
    }
    if (fileField) {
        filename = $fileField
        component = $1
        if (fileField > 2) { # if the file field is more than 2, process subcomponents
            for (i = 2; i < fileField; i++) {
                if (subcomponent) { # if we've already found a subcomponent, format it nicely
                    subcomponent = sprintf("%s / %s", subcomponent, $i) 
                } else {
                    subcomponent = $i
                }
            }
        }
        color = "(PRIMARY)" # default color is primary
        if (filename ~ /^\[a\]/) {
            color = "(ACCENT)" # ...unless the part is noted as accent
            sub(/^\[a\]_/, "", filename) # for the part name, remove the accent marker
        } else if (filename ~ /^\[o\]/) {
            color = "(OPAQUE)"
            sub(/^\[o\]_/, "", filename)
        } else if (filename ~ /^\[c\]/) {
            color = "(CLEAR)"
            sub(/^\[c\]_/, "", filename)
        }

        quantity = 1
        if (filename ~ /x[[:digit:]]+\.stl$/) {
            quantity = gensub(/.*x([[:digit:]]+)\.stl$/, "\\1", "g", filename)
        }

        sub(/(_x[[:digit:]]+)?\.stl$/, "", filename) # for the part name, remove the extension and quantity

        # convert underscore to space in non-filename fields
        gsub(/_/, " ", filename)
        gsub(/_/, " ", component)
        gsub(/_/, " ", subcomponent)

        printf("%s,%s,%s,%s,%d,%s,0,\"%s\"\n",filename,component,subcomponent,color,quantity,$0,link)
    } else { # no file field was found, which is probably a problem
        print "ERROR WILL ROBINSON"
    }
}
