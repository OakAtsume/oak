#!/usr/bin/env bash
# -*- coding: utf-8 -*-
# Version: v.3
#  Website-Needle Release
# Creator: Neko Oak atsume.

# Fuck me perhaps? owo

function log.cons() {
    local text="${1}"
    printf "\e[38;2;255;255;0m[*]\e[m: ${text}\n"
}
function log.err() {
    local text="${1}"
    printf "\e[38;2;255;0;0m[!]\e[m: ${text}\n"
}
function log.que() {
    local text="${1}"
    printf "\e[38;2;0;255;255m[?]\e[m: ${text}\n"
}
function writeline() {
    printf "\e[${1}H${2}"
}
printf "\e[38;2;255;182;193m
                                  █████ ████
                                 ░░███ ░░███
 ████████    ██████   ██████   ███████  ░███   ██████
░░███░░███  ███░░███ ███░░███ ███░░███  ░███  ███░░███
 ░███ ░███ ░███████ ░███████ ░███ ░███  ░███ ░███████
 ░███ ░███ ░███░░░  ░███░░░  ░███ ░███  ░███ ░███░░░
 ████ █████░░██████ ░░██████ ░░████████ █████░░██████
░░░░ ░░░░░  ░░░░░░   ░░░░░░   ░░░░░░░░ ░░░░░  ░░░░░░\e[m\n\n"
if [[ -z "${1}" ]]; then
    log.err "No values passed, If you need help or aren't sure what to do please add the '--help' flag"
   exit 2
fi

case "${1}" in
    -h|--help|--h|help)
        log.cons "Usage: needle [OPTION] [FILE] [FILE]"
        printf "\t[Flags]\t\t[Value]\t\t[Value]\t\t[File]\n"
        printf "\tinject\t\tFile1\t\tFile2\n"
        printf "\thexinject\tFile1\t\tFile2\n"
        printf "\treplace\t\t'data'\t\t'new data'\tFile\n"
        printf "\thexreplace\t'hex'\t\t'hex'\t\tFile\n"
        # printf "\tconsole\n"
    ;;
    replace)
    if [[ -z "${3}" ]]; then
        log.err "Missing Values, if you are confused please add the '--help' flag"
        exit 1
    fi
    DataToSeek="${2}"
    NewData="${3}"
    File="${4}"
    if [[ ! -f "${File}" ]]; then
        log.err "I'm unable to locate ${File}"
        exit 1
    else
        log.cons "File Located [${File}]"
    fi
    if [[ ! -w "${File}" ]]; then
        log.err "I'm unable to write ${File}"
        exit 2
    else
        log.cons "File is writeable [${File}]"
    fi
    if [[ ! -r "${File}" ]]; then
        log.err "I'm unable to read ${File}"
        exit 2
    else
        log.cons "File is readable [${File}]"
    fi
    # Start #
    log.err "Hey if ${File} is bigger than your total memory it will crash the system!"
    log.err "If this is the case press ^C to kill and re-run with the 'slowreplace' flag!"
    log.cons "Starting in 3 seconds..."
    read -rt "3" <> <(:) || :
    log.cons "Starting!"
    read -rt "1" <> <(:) || :
    clear # Replace me! with pure bash alternative!!
    log.cons "Mapping ${File}, into memory"
    if readarray FileMap < "${File}"; then
        log.cons "[${File}], Has been mapped out into a strand of ${#FileMap[*]} elements"
    else
        log.err "Unable to map file!"
        exit 1
    fi
    log.cons "Purging File..."
    
    if :> "${File}"; then
        log.cons "${File}, has been purged"
    else
        log.err "Unable to purge ${File}!"
        exit 1
    fi
    read -rt "1" <> <(:) || : 
    matches=();
    clear
    totalstrands="${#FileMap[*]}"
    for (( a = 0; a <= "${totalstrands}"; a++)); do
        if [[ ${FileMap[a]} =~ ${DataToSeek} ]]; then
            matches+=("${a}");
            writeline 1 "[${a}/${totalstrands}] : Match Found!"
            echo -n "${FileMap[a]//${DataToSeek}/${NewData}}" >> "${File}"
            unset "FileMap[${a}]"
        else
            writeline 1 "[${a}/${totalstrands}] : Line Skipped"
            echo -n "${FileMap[a]}" >> "${File}"
            unset "FileMap[${a}]"
        fi
        writeline 2 "Strand size [${#FileMap[*]}]"
        read -rt "0.1" <> <(:) || : # Timeout just for testing!
    done
    printf "\n"
    log.cons "\nDone! Exit-Code: [$?] Total-strand-size: [${totalstrands}]"
    if unset FileMap; then
        log.que "Removed strand (Just in case)"
    else
        log.err "Unable to clear memory (Continuing anyways!)"
    fi
    ;;
esac