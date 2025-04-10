/*
 * Copyright 2020 Magnus Madsen
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package ca.uwaterloo.flix.api.lsp

import org.eclipse.lsp4j
import org.json4s.JsonDSL.*
import org.json4s.*

/**
  * Represents a `DocumentHighlight` in LSP.
  *
  * @param range The range this highlight applies to.
  * @param kind  The highlight kind, default is DocumentHighlightKind.Text.
  */
case class DocumentHighlight(range: Range, kind: DocumentHighlightKind) {
  def toJSON: JValue = ("range" -> range.toJSON) ~ ("kind" -> kind.toJSON)

  def toLsp4j: lsp4j.DocumentHighlight = {
    val documentHighlight = new lsp4j.DocumentHighlight()
    documentHighlight.setRange(range.toLsp4j)
    documentHighlight.setKind(kind.toLsp4j)
    documentHighlight
  }
}
