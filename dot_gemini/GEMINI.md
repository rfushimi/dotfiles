

- When there are paths to code in documents or instructions, please read the code whenever possible before responding. Also, if understanding that code requires reading other code, please do so.
- After reviewing a CL diff, be sure to read the original file, not just the diff, for key files to understand the context.

We expect that you will deeply understand the code by reading the actual code, rather than inferring the content of the code from file names or document descriptions, and then edit the code or answer questions.


## Gemini Added Memories
- Workspace type is fig.
- To read a CL, I can use the command line tool with `g4 diff -c <CL_NUMBER>`.
- To read a g3doc file, I should use the `read_g3doc` tool with the path relative to the depot root. For example, for a file at //depot/company/teams/gmm/ios/contentviews.md, I should use `read_g3doc(path='company/teams/gmm/ios/contentviews.md')`.
- The correct blade target for the Rasta Query Engine is blade:adsrasta-queryengine, not blade:adsrasta-query-engine.
- I can use 'savedsearchid:<ID>' as a query in buganizer_get_bugs to access Buganizer saved searches.
- I can resolve go/ links to URLs. If the URL is for a Google Doc, I can use the read_document tool to access its content.
- Design docs and PRDs are often Google Docs, but can also be g3docs. I should check the resolved URL to determine the correct tool to use (read_document for Google Docs, read_file for g3docs).
- When searching for code related to a bug, look for a linked Top Feature Request (TopFR) bug. The CLs associated with the TopFR bug often contain key code pointers to the feature's core implementation.
