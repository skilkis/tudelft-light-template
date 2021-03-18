% -----------------------------------------------------------------------------
%
% Copyright (c) 2020. San Kilkis. All rights reserved.
%
% This Source Code Form is subject to the terms of the Mozilla Public
% License, v. 2.0. If a copy of the MPL was not distributed with this
% file, You can obtain one at http://mozilla.org/MPL/2.0/
%
% --- Class Documentation: ----------------------------------------------------
%
% This package provides the tudelft-light/report class for use with XeLaTeX.
%
% The document class is based on the report class from the LaTeX Std. Lib.
% For a full list of available document options refer to:
% https://en.wikibooks.org/wiki/LaTeX/Document_Structure
%
% Optional Keyword Arguments:
%   fancyheader (bool): Turns the fancy header On/Off.
%
% Note:
%   To make it easier to navigate the code, several subpackages have been
%   created which can be summarized as follows:
%
%       * style.sty: Contains style definitions such as color and fonts
%       * setup.sty: Contains macros for document metadata setup
%       * cover.sty: Contains the \makecover macro for the outer cover page
%       * title.sty: Containts the \maketitle macro for the inner title page
%       * macros.sty: Contains custom macros and environments.
%
% -----------------------------------------------------------------------------

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{tudelft-light/tud-report}

\RequirePackage{iftex}
\RequireXeTeX % Raises error if not compiling with XeLaTeX

% --- Class Options: ----------------------------------------------------------
\RequirePackage{kvoptions}

% Simplifying family name, otherwise it would be tudelft-light/report
\SetupKeyvalOptions{
    family=tud,
    prefix=tud@,
}

\DeclareBoolOption{fancyheader}

% Passing all unspecified options to the report class of the LaTeX Std. Lib.
\DeclareDefaultOption{\PassOptionsToClass{\CurrentOptionKey}{report}}
\ProcessKeyvalOptions*
\LoadClass{report}

% --- Importing 3rd Party Packages: -------------------------------------------
\def\tud@margin{6pc}
\def\tud@headheight{14pt}
\RequirePackage{etoolbox}  % Required by automatic removal of references
\RequirePackage[nottoc]{tocbibind}  % Adds entires like list of figures to ToC
\RequirePackage{calc}
\RequirePackage{import}
\RequirePackage{xcolor} % Useful for colored tables!
\RequirePackage{amsfonts}
\RequirePackage{amsmath}
\RequirePackage{amssymb}
\RequirePackage{mathtools}
\RequirePackage[super]{nth}
\RequirePackage{graphicx}
\RequirePackage{tikz}
\RequirePackage{fontspec}
\RequirePackage{pgfplots}
\RequirePackage{datatool}
\RequirePackage{tabularx}
\RequirePackage{rotating}
\RequirePackage{pdflscape}
\RequirePackage{float}
\RequirePackage{booktabs}
\RequirePackage{color} % FIXME Find out if this package is redundant
\RequirePackage{titlesec}
\RequirePackage{caption}
\RequirePackage{enumitem}
\RequirePackage{subcaption}
\RequirePackage{pdfpages}
\RequirePackage[hyphens]{url}
\RequirePackage{hyphenat}
\RequirePackage{array}
\RequirePackage{fancyhdr} % Inserts a fancy smancy header into sub-pages
\RequirePackage[fit, breakall]{truncate} % Used w/ fancyhdr to fix overlap
\RequirePackage{notoccite}
\RequirePackage[symbol]{footmisc}
\RequirePackage{minted}
\RequirePackage{siunitx}
\RequirePackage[titletoc]{appendix}
\RequirePackage[hidelinks, unicode, pdfpagelabels=true]{hyperref}
\RequirePackage{blindtext} % Useful for debugging
\RequirePackage{arydshln} % Used for adding dashlines in arrays \hdashline
\RequirePackage{tablefootnote} % Put footnotes in tables
\RequirePackage[intoc]{nomencl}
\RequirePackage[us]{datetime}
\RequirePackage{xkeyval} % Needed for optional keyword arguments to macros
\RequirePackage{listofitems} % Allows creation of list from delimited string

% Automated Referencing: WARNING HAS TO BE LOADED AFTER hyperref
\RequirePackage[capitalise, noabbrev, nameinlink]{cleveref}
\RequirePackage[%
    backend=biber,
    style=numeric,
    citestyle=numeric,
    sorting=none
]{biblatex}

% --- Document Layout & Title Margins: ----------------------------------------
% Set default margins conditionally based on the twoside option. This
% implementation allows options to be later passed to the geometry package with
% the \PassOptionsToPackage macro and is thus more configurable than hardcoding
% a \geometry declaration inside the class file.
\def\tud@margin{6pc}
\def\tud@headheight{14pt}
\RequirePackage[
    \if@twoside
        margin=\tud@margin,
        inner=\tud@margin+1pc,
        outer=\tud@margin-1pc,
        headheight=\tud@headheight
    \else
        margin=\tud@margin,
        headheight=\tud@headheight
    \fi
]{geometry}

% Adjust chapter format
\titlespacing*{\chapter}{0pt}{-25pt}{10pt}
\definecolor{gray75}{gray}{0}
\newcommand{\hsp}{\hspace{3pt}}
\titleformat{\chapter}[hang]%
    {\Huge\bfseries}%
    {\thechapter\hsp\textcolor{gray75}\hsp}%
    {10pt}{\Huge\bfseries}

\setlength{\parindent}{0cm} % No indent on paragraphs

% --- Chapter Naming & Numbering Configuration: -------------------------------

% Changing name of Contents to Table of Contents
\renewcommand{\contentsname}{Table of Contents}

% Bool: True when inmainmatter, defaults to true for compat.
\newif\if@mainmatter\@mainmattertrue

% Bool: True when in cover/title pages, defaults to false for compat.
\newif\if@titlepage\@titlepagefalse

\def\mainmatter@pagestyle{
    % Defines the mainmatter page style based on the fancyheader option
    \iftud@fancyheader
        \pagestyle{fancytruncated} % Display a fancy header on subsequent pages
    \else
        \pagestyle{plain}
    \fi
}

\newcommand{\frontmatter}{
    % Disables chapter numbers and numbers pages with roman numerals
    %
    % Usage:
    %
    %   \frontmatter
    %       \include{chapters/preface}
    \cleardoublepage
    \@mainmatterfalse
    \pagenumbering{roman}
    \pagestyle{plain}
}

\newcommand{\mainmatter}{
    % Enables chapter numbers and numbers pages with arabic numerals
    %
    % Usage:
    %
    %   \mainmatter
    %       \include{chapters/introduction}
    \cleardoublepage
    \@mainmattertrue
    \pagenumbering{arabic}
    \mainmatter@pagestyle
}

\def\@chapter[#1]#2{%
    % Disables page numbering in front/backmatter (taken from book.cls)
    \ifnum \c@secnumdepth > \m@ne % Is greater than minus one?
        \if@mainmatter
            \refstepcounter{chapter}%
            \typeout{\@chapapp\space\thechapter.}%
            \addcontentsline{toc}{chapter}{\protect\numberline{\thechapter}#1}%
        \else
            \phantomsection
            \addcontentsline{toc}{chapter}{#1}%
        \fi
    \else
        \addcontentsline{toc}{chapter}{#1}%
    \fi
    \chaptermark{#1}%
    \addtocontents{lof}{\protect\addvspace{10\p@}}%
    \addtocontents{lot}{\protect\addvspace{10\p@}}%
    \if@twocolumn
        \@topnewpage[\@makechapterhead{#2}]%
    \else
        \@makechapterhead{#2}%
        \@afterheading%
    \fi
}

% --- Header & Footnote Configuration: ----------------------------------------
% Uses the truncate package to crop long section and chapter titles
% Once the specified width is exceeded the title is split, the left
% portion is kept, and `...' dots are appended to the end
\fancypagestyle{fancytruncated}{%
    \fancyhead[R]{\itshape\small \truncate{0.47\textwidth} \leftmark}
    \fancyhead[L]{\itshape\small \truncate{0.47\textwidth} \rightmark}
}

\iftud@fancyheader
    \pagestyle{fancytruncated} % Display a fancy header on subsequent pages
\fi

% Footnote style Roman numerals
\renewcommand{\thefootnote}{\roman{footnote}}

% --- Nomenclature Categories and Configuration: ------------------------------
\makenomenclature

\renewcommand\nomgroup[1]{%
    \item[\bfseries
        \ifthenelse{\equal{#1}{G}}{Greek Symbols}{%
        \ifthenelse{\equal{#1}{B}}{Roman Symbols}{%
        \ifthenelse{\equal{#1}{S}}{Subscripts}{%
        \ifthenelse{\equal{#1}{T}}{Superscripts}{%
        \ifthenelse{\equal{#1}{A}}{Abbreviations}{}}}}}%
    ]}

% Renames Nomenclature to List of Symbols
\renewcommand{\nomname}{List of Symbols}


\newcommand{\nomunit}[2][\relax]{%
    % Formats the units of the nomenclature
    %
    % Usage:
    %
    %   \nomunit{\kilogram}
    %
    % To have access to the \SI{}{} environment, a number can be passed using
    % an optional argument as follows:
    %
    %   \nomunit[9.81]{\meter\per\second}
    %
    % Optional Arguments:
    %   1 (number): Sets the value of the unit (useful for constants)
    %
    % Positional Arguments:
    %   2 (macro): Set of un-expanded SI macros
    \renewcommand{\nomentryend}{%
        \if#1\relax{}
            \hspace*{\fill}\si{#2}
        \else
            \hspace*{\fill}\SI{#1}{#2}
        \fi
    }
}

% --- Plot Configuration: -----------------------------------------------------
\pgfplotsset{compat=1.16} % Setting compatibility for PGF Plots

% --- Table Spacing & Layout Parameters: --------------------------------------
\renewcommand{\arraystretch}{1.2}
\newcolumntype{C}{>{\small\centering\arraybackslash}X} %For tabularX
\newcolumntype{L}{>{\small\raggedright\arraybackslash}X} %For tabularX
\newcolumntype{R}{>{\small\raggedleft\arraybackslash}X} %For tabularX
\newcolumntype{P}[1]{>{\centering\arraybackslash}p{#1}} % centered p column

%Changes parameters for \hdashline to make the dashes into dots:
\setlength\dashlinedash{0.2pt}
\setlength\dashlinegap{1.5pt}
\setlength\arrayrulewidth{0.3pt}

% --- Math Configuration: -----------------------------------------------------
% Removes Parenthesis around Equation labels
\creflabelformat{equation}{#2\textup{#1}#3}

% --- Biblography Configuration: ----------------------------------------------
\addbibresource[glob]{*.bib}  % Automatically add any .bib file as a resource
\renewcommand*{\bibfont}{\raggedright} % Remove justification from bib.
\newcommand{\BibliographyName}{References} % Name of Biblography

\defbibheading{bibliography}[\bibname]{
    % Remove duplication from header when using fancyhdr
    %
    % Usage:
    %   \printbibliography[heading=bibliography]
    \chapter*{#1}%
    \markboth{\MakeUppercase{#1}}{}
}

\defbibheading{bibintoc}[\bibname]{
    % Remove duplication from header and add bibliography to ToC
    %
    % Usage:
    %   \printbibliography[heading=bibintoc]
    \chapter*{#1}%
    \addcontentsline{toc}{chapter}{#1}%
    \markboth{\MakeUppercase{#1}}{}%
}

% --- Caption Configuration: --------------------------------------------------

% The code below patches LoF, LoT, and LoL to remove citations
\let\cite@old\cite
\pretocmd{\listoffigures}{\def\cite{\ignorespaces\@gobble}}{}{}
\apptocmd{\listoffigures}{\let\cite\cite@old}{}{}

\pretocmd{\listoftables}{\def\cite{\ignorespaces\@gobble}}{}{}
\apptocmd{\listoftables}{\let\cite\cite@old}{}{}

\pretocmd{\listoflistings}{\def\cite{\ignorespaces\@gobble}}{}{}
\apptocmd{\listoflistings}{\let\cite\cite@old}{}{}

% --- Importing TU Delft Light Packages: --------------------------------------
\RequirePackage{tudelft-light/tud-style}
\RequirePackage{tudelft-light/tud-setup}
\RequirePackage{tudelft-light/tud-cover}
\RequirePackage{tudelft-light/tud-title}
\RequirePackage{tudelft-light/tud-macros}
\RequirePackage{tudelft-light/tud-environments}
