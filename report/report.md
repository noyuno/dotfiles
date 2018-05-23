テスト用

# セクション(section)

## subsection

### subsubセクション

本文本文本文本文本文本文本文本文本文本文本文本文本文本文本文本文本文本文本文本文本文本文本文本文本文本文本文本文本文本文本文本文本文本文本文本文本文本文本文本文本文本文本文本文本文本文本文本文本文本文本文本文本文本文本文本文本文本文本文本文

- **項目**:説明説明説明説明説明説明
- **Keyword**:説明説明説明説明説明説明

- 箇条書き
  - 第2レベル箇条書き
    - 第3レベル箇条書き
      - 第4レベル箇条書き

1. 箇条書き
1. 第2レベル箇条書き
1. 箇条書き

列A      列B
------   --------
アイテム アイテム
アイテム アイテム
アイテム アイテム
アイテム アイテム

\begin{table}[H]
\centering
\caption{sample table \label{tab:ta}}
\begin{tabular}{|c|c|} \hline
a & b \\ \hline
c & d \\ \hline
\end{tabular}
\end{table}

\begin{figure}[H]
\centering
\includegraphics[width=8cm]{./sample/1.png}
\caption{sample figure \label{fig:fi}}
\end{figure}

\begin{figure}[H]
\begin{minipage}{0.5\hsize}
    \centering
    \includegraphics[width=6cm]{./sample/1.png}
    \subcaption{left \label{fig:2fig1}}
\end{minipage}
\begin{minipage}{0.5\hsize}
    \centering
    \includegraphics[width=6cm]{./sample/2.png}
    \subcaption{right \label{fig:2fig2}}
\end{minipage}
\caption{2 figures \label{fig:2fig}}
\end{figure}


\begin{lstlisting}[language=python,caption=hello code \label{src:hello}]
    print("hello world")
\end{lstlisting}


