\RequirePackage { expl3 , l3keys2e }

\ProvidesExplClass
  {tufte-thesis}
  {2017/12/12}
  {0.01}
  {A Tufte-like thesis class derived from tufte-book}


\RequirePackage { xparse }

%%%%%%%%%%%%%%%%%
% Class options %
%%%%%%%%%%%%%%%%%

\tl_new:N \l_thesis_class_tl

\keys_define:nn { tufte-thesis }
  {
    class .tl_gset:N = \l_thesis_class_tl ,
    class .value_required:n = true ,

    class .initial:n = tufte-book
  }

\keys_define:nn { tufte-thesis }
  {
    tufte-book .choice: ,
    tufte-book / true .meta:n = { class = tufte-book } ,
    tufte-book / false .meta:n = { class = tufte-handout } ,

    tufte-book .default:n = true
  }

\keys_define:nn { tufte-thesis }
  {
    tufte-handout .choice: ,
    tufte-handout / true .meta:n = { class = tufte-handout } ,
    tufte-handout / false .meta:n = { class = tufte-book } ,

    tufte-handout .default:n = true
  }


\bool_new:N \l_thesis_libertine_bool

\keys_define:nn { tufte-thesis }
  {
    libertine .bool_set:N = \l_thesis_libertine_bool ,
    libertine .default:n = true ,

    libertine .initial:n = true ,
  }


\tl_new:N \l_thesis_biboptions_tl

\keys_define:nn { tufte-thesis }
  {
    biblatex .tl_gset:N = \l_thesis_biboptions_tl ,
    biblatex .value_required:n = true ,
  }


%%%%%%%%%%%%%%%%%
% Color schemes %
%%%%%%%%%%%%%%%%%

\keys_define:nn { tufte-thesis }
  {
    color~scheme .code:n =
      \keys_set:nn { tufte-thesis / colors } {#1}
    ,
  }

\clist_map_inline:nn { structure , code }
  {
    \keys_define:nn { tufte-thesis / colors }
      {
        #1 .code:n = \colorlet {#1} {##1} ,
        #1 .value_required:n = true
      }
  }


%%%%%%%%%%%%%%
% Base class %
%%%%%%%%%%%%%%

\ProcessKeysOptions { tufte-thesis }

\PassOptionsToClass
  { justified , nobib }
  { \l_thesis_class_tl }

\bool_if:NT \l_thesis_libertine_bool
  { \PassOptionsToClass { nofonts } { \l_thesis_class_tl } }

\LoadClass { \l_thesis_class_tl }


% 

\RequirePackage { xcolor }

\xdefinecolor { beachblue } { HTML } { 046380 }
\xdefinecolor { firenzered } { HTML } { 8E2800 }

\keys_define:nn { tufte-thesis / colors }
  {
    structure .initial:n = beachblue ,
    code      .initial:n = beachblue ,
  }


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Fonts and microtypography %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\bool_if:NT \l_thesis_libertine_bool
  {
    %% Libertine roman text
    \PassOptionsToPackage
      { semibold , lining , tt = false }
      { libertine }
    \RequirePackage { libertine }
  }

\PassOptionsToPackage { T1 } { fontenc }
\RequirePackage { fontenc }

\PassOptionsToPackage
  { supstfm = libertinesups , supscaled = 1.2 , raised = -.13em }
  { superiors }
\RequirePackage { superiors }


\makeatletter
\long\def\@makefntext#1{\llap{\textsu{\@thefnmark}\,}\footnotelayout#1}
\makeatother


%% Microtypography
\PassOptionsToPackage
  {
    expansion = false ,
    tracking = smallcaps ,
    letterspace = 40
  } { microtype }

\RequirePackage { microtype }

%% Math fonts

% Other math fonts
\RequirePackage { amsmath }
\RequirePackage { amssymb }

\PassOptionsToPackage { heavycircles } { stmaryrd }
\RequirePackage { stmaryrd }

% newtx math fonts
\bool_if:NT \l_thesis_libertine_bool
  {
    \RequirePackage { amsthm }

    \PassOptionsToPackage
      { libertine , cmintegrals , bigdelims , vvarbb , liby }
      { newtxmath }
    \RequirePackage { newtxmath }
  }

% Switch to old-style figures in text
\useosf


%%%%%%%%%%%%%
% Sidenotes %
%%%%%%%%%%%%%

\RequirePackage { mparhack }


%%%%%%%%%%%%%%%%%%%%%
% Table of Contents %
%%%%%%%%%%%%%%%%%%%%%

\setcounter{tocdepth}{2} % Show sections and subsections


%%%%%%%%%%%%%%%%%%%
% Format of heads %
%%%%%%%%%%%%%%%%%%%

\setcounter { secnumdepth } { 2 } % Numbering for sections

%% Italic A- and B-heads with margin numbering
\titleformat { \section } [ hang ]
  { \Large \itshape \color{ structure } }
  { \llap { \normalfont \thesection \kern1em } }
  { 0em }{}[]

\titleformat { \subsection } [ hang ]
  { \large \itshape \color{ structure } }
  { \llap { \normalfont \thesubsection \kern1em } }
  { 0em } { } [ ]

%% Small caps run-in unnumbered C-heads
\titleformat { \paragraph } [ runin ]
  { \scshape \color{ structure } }
  { }
  { 1em } { \MakeTextLowercase } [ ]


%%%%%%%%%%%%%%%%
% Inline lists %
%%%%%%%%%%%%%%%%

\PassOptionsToPackage { inline } { enumitem }
\RequirePackage { enumitem }


%%%%%%%%%%%%%%%%%%%%%%%%
% Theorem environments %
%%%%%%%%%%%%%%%%%%%%%%%%

\RequirePackage { amsthm }

%% Small caps theorem styles
\newtheoremstyle { smallcaps-plain }
  { \topsep } { \topsep } % Space above and below
  { \itshape } % Body font
  { } % Indent length
  { } % Theorem head font
  { } % Punctuation after theorem head
  { .5em } % Length after theorem head
  {
    \textsc { \color { structure } \MakeTextLowercase {
      \thmname {#1}  \thmnumber {~#2} }
    }
    \thmnote {~(#3)}
  } % Theorem head spec

\newtheoremstyle { smallcaps-definition }
  { \topsep } { \topsep } % Space above and below
  { } % Body font
  { } % Indent length
  { } % Theorem head font
  { } % Punctuation after theorem head
  { .5em } % Length after theorem head
  {
    \textsc { \color { structure } \MakeTextLowercase {
      \thmname {#1}  \thmnumber {~#2} }
    }
    \thmnote {~(#3)}
  } % Theorem head spec

%% Proof environment 
\cs_set_eq:NN \__proof \proof
\cs_set_eq:NN \__endproof \endproof

\RenewDocumentEnvironment { proof } { O{ Proof } }
  { \__proof [ \color { structure } #1 ] }
  { \__endproof }

%% Some theorem-like environments
\theoremstyle { smallcaps-plain }
\newtheorem { theorem } { Theorem }
\newtheorem* { theorem* } { Theorem }
\newtheorem { lemma } [ theorem ] { Lemma }
\newtheorem* { lemma* } { Lemma }
\newtheorem { corollary } [ theorem ] { Corollary }
\newtheorem* { corollary* } { Corollary }
\newtheorem { fact } [ theorem ] { Fact }
\newtheorem* { fact* } { Fact }
\newtheorem { falseclaim } [ theorem ] { False~Claim }
\newtheorem* { falseclaim* } { False~Claim }
\newtheorem { conjecture } [ theorem ] { Conjecture }
\newtheorem* { conjecture* } { Conjecture }

\theoremstyle { smallcaps-definition }
\newtheorem { definition } { Definition }
\newtheorem* { definition* } { Definition }
\newtheorem { example } { Example }
\newtheorem* { example* } { Example }

%% QED symbol in structure color
\cs_set:Npn \qedsymbol { $ \color { structure } \blacksquare $ }

%% Description environment for use in theorems/definitions
\PassOptionsToPackage { inline } { enumitem }
\RequirePackage { enumitem }

\newlist { thmdescription } { description } { 1 }
\setlist [ thmdescription ] { nosep , leftmargin=1.25em ,  , font=\emph }


%%%%%%%%%%%%%%%%%%%%%%%%%
% Labels and references %
%%%%%%%%%%%%%%%%%%%%%%%%%

\RequirePackage { cleveref }


%%%%%%%%%%%%%%%%
% Bibliography %
%%%%%%%%%%%%%%%%

\exp_args:No \PassOptionsToPackage { \l_thesis_biboptions_tl } { biblatex }
\RequirePackage { biblatex }


%%%%%%%%%%%%%
% Utilities %
%%%%%%%%%%%%%

\RequirePackage { import }