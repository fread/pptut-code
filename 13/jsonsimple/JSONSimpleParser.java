package jsonsimple;

import java.io.IOException;
import java.math.BigInteger;
import java.nio.ByteBuffer;
import java.nio.charset.Charset;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.Arrays;
import java.util.LinkedList;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;


enum TokenType {
	EOF(null),
	LCURLY("\\{"),
	RCURLY("\\}"),
	COLON(":"),
	COMMA(","),
	WHITESPACE("\\s+"),
	STRING("\"(([^\"\\\\\\u0000-\\u001F]|(\\\\[\"\\\\/bfnrt])|(\\\\u[0-9a-fA-F]{4}))*)\"", true),
	NUMBER("(-?(0|[1-9][0-9]*)(\\.[0-9]+)?)([eE]?[+-]?[0-9]+)?", true);

	/**
	 * The regular expression matching character sequencing corresponding to this TokenType.
	 */
	public final String regexp;

	/**
	 * Shall token of this type remember the characters matched during lexing?
	 */
	public final boolean rememberCharacters;

	TokenType(String regexp, boolean rememberCharacters) {
		this.regexp = regexp;
		this.rememberCharacters = rememberCharacters;
	}

	TokenType(String regexp) {
		this(regexp, false);
	}


	static final TokenType[] NOEOF = {LCURLY, RCURLY, COLON, COMMA, WHITESPACE, STRING, NUMBER};
	static {
		assert NOEOF.length == TokenType.values().length - 1;
	}

	public static final Pattern TOKENPATTERN;
	static {
		final StringBuilder tokenPattern = new StringBuilder();
		String sep = "";
		for (TokenType t : TokenType.NOEOF) {
			tokenPattern.append(String.format("%s(?<%s>%s)", sep, t.name(), t.regexp));
			sep = "|";
		}
		TOKENPATTERN = Pattern.compile(tokenPattern.toString());
	}

}

public final class JSONSimpleParser {
	private JSONSimpleParser() {
	}

	private static Token token;
	private static Matcher tokenMatcher;

	/**
	 * Sets the current input token to the next token read from Input.
	 *
	 * @return true, iff another input token other than {@link TokenType#EOF} was read.
	 *
	 * @throws IllegalStateException iff no tokenMatcher was set (see {@link #setInput(String)}).
	 * @throws LexerError iff the input cannot be correctly tokenized (e.g., if it contains characters not corresponding to tokens).
	 */
	private static boolean nextToken() {
		if (tokenMatcher == null) throw new IllegalStateException();

		do {
			final int previouslyMatchedCharacterIndex = (token == null) ? 0 : tokenMatcher.end();

			if (tokenMatcher.find()) {
				// Abort if tokenMatcher had to skip characters in order to find the next valid token
				if (tokenMatcher.start() > previouslyMatchedCharacterIndex) throw new LexerError();

				// The characters matched correspond to exactly one new Token.
				// Generate this, possibly annotating it with the matched character sequence
				boolean matchingTokenFound = false;
				for (TokenType t : TokenType.NOEOF) {
					boolean tokenMatches = tokenMatcher.group(t.name()) != null;

					// The token, as defined in TokenType, are "mutually exclusive":
					assert !(matchingTokenFound && tokenMatches);

					matchingTokenFound |= tokenMatches;

					if (tokenMatches) {
						token = new Token(t, tokenMatcher.group(t.name()));
					}
				}
				assert matchingTokenFound;

			} else {
				// Abort if no more tokens could be found, but the input has not been fully read yet.
				if (previouslyMatchedCharacterIndex < tokenMatcher.regionEnd()) throw new LexerError();

				token = new Token(TokenType.EOF);
				return false;
			}
		} while (token.getType() == TokenType.WHITESPACE);

		return true;
	}

	/**
	 * Sets the input to be parsed.
	 * @param input the input to be parsed. Must be != null.
	 * @return true iff the first token differs from {@link TokenType#EOF}
	 */
	public static boolean setInput(String input) {
		if(input == null) throw new IllegalArgumentException();

		tokenMatcher = TokenType.TOKENPATTERN.matcher(input);
		token = null;
		return nextToken();
	}

	private static void error() {
		throw new ParseError();
	}

	private static void printTokens() {
		do {
			System.out.print(token + ", ");
		} while(nextToken());
	}

	/**
	 *
	 * @return the {@link JSONValue} represented by the Sting last input (see {@link #setInput(String)}
	 * @throws LexerError if the input String cannot be tokenized
	 * @throws ParseError if the input token stream cannot be properly parsed as a {@link JSONValue}
	 * @throws IllegalStateException if no input String was set
	 */
	public static JSONValue parseValue() {
		switch (token.getType()) {
		case STRING: {
			JSONValue result = new JSONString(token.getSymbol());
			nextToken();
			return result;
		}

		case NUMBER: {
			JSONValue result = new JSONNumber(token.getSymbol());
			nextToken();
			return result;
		}

		case LCURLY: {
			JSONValue result = parseObject();
			return result;
		}

		default:
			error();
		}

		throw new ParseError();
	}

	private static JSONObject parseObject() {
		assert(token.getType() == TokenType.LCURLY);
		nextToken();

		MyList membersList = parseMembers();

		assert(token.getType() == TokenType.RCURLY);
		nextToken();

		return new JSONObject(membersList);
	}

	private static MyList parseMembers() {
		Pair p = parsePair();
		MyList l = parseMembers_(p);
		return l;
	}

	private static MyList parseMembers_(Pair p) {
		switch (token.getType()) {
		case COMMA:
			nextToken();
			MyList restMembers = parseMembers();
			return new Cons(p, restMembers);

		case RCURLY:
			return new Singleton(p);

		default:
			error();
		}

		throw new ParseError();
	}

	private static Pair parsePair() {
		assert(token.getType() == TokenType.STRING);
		JSONString key = new JSONString(token.getSymbol());


		nextToken();
		assert(token.getType() == TokenType.COLON);

		nextToken();
		JSONValue value = parseValue();

		return new Pair(key, value);
	}

	public static void main(String[] args) throws IOException {
		switch (args.length) {
			case 0: test(); break;
			case 1: expectCorrect(args[0]); break;
			default:
		}
	}

	private static void expectCorrect(String correct) {
		// If no token are found: signal error
		if (!setInput(correct)) error();

		// show token stream
		printTokens(); System.out.println();
		System.out.println(correct);

		// parse it
		setInput(correct);
		final JSONValue v = parseValue();

		// If token remain, the full input string wasn't a legal type, so we signal an error
		if (token.getType() != TokenType.EOF) error();

		System.out.println("Parsed: \t" + v);
	}

	static String readFile(Path path, Charset encoding) throws IOException {
		  byte[] encoded = Files.readAllBytes(path);
		  return encoding.decode(ByteBuffer.wrap(encoded)).toString();
	}

	private static void test() throws IOException {
		List<String> parsable = new LinkedList<String>();
		for (Path p : Files.newDirectoryStream(Paths.get("jsonsimple", "data"), "*.{json}")) {
			parsable.add(readFile(p, StandardCharsets.UTF_8));
		}
		for (String correct : parsable) {
			expectCorrect(correct);
		}
	}


}


final class Token {
	private final String symbol;
	private final TokenType tokentype;

	public String getSymbol() {
		return symbol;
	}

	public Token(TokenType tokentyp) {
		this(tokentyp, null);
	}

	public Token(TokenType tokentyp, String symbol) {
		if (tokentyp.rememberCharacters && (symbol == null)) throw new IllegalArgumentException();

		this.tokentype = tokentyp;
		this.symbol = tokentyp.rememberCharacters ? symbol : null;
	}

	public TokenType getType() {
		return tokentype;
	}

	@Override
	public String toString() {
		return "<" + tokentype + (symbol != null ? "(" + symbol + ")" : "") + ">";
	}

}

abstract class JSONValue {
}

final class Pair {
	private JSONString s;
	private JSONValue v;
	public Pair(JSONString s, JSONValue v) {
		if (s == null || v == null) throw new IllegalArgumentException();

		this.s = s;
		this.v = v;
	}

	@Override
	public String toString() {
		return  s + " : " + v;
	}
}

class JSONString extends JSONValue {
	private String s;
	public JSONString(String s) {
		if (s == null || !s.matches(TokenType.STRING.regexp)) throw new IllegalArgumentException();

		// TODO: translate escaped character sequences such as
		// \n,\t,\", ... ,\u20ac
		assert s.matches("\".*\"");
		this.s = s.substring(1, s.length() - 1);
	}

	@Override
	public String toString() {
		return "\"" + s + "\"";
	}
}

class JSONNumber extends JSONValue {
	private Number n;
	public JSONNumber(String n) {
		if (n == null || !n.matches(TokenType.NUMBER.regexp)) throw new IllegalArgumentException();

		if (n.contains(".") || n.contains("e") || n.contains("E")) {
			this.n = Double.parseDouble(n);
		} else {
			this.n = new BigInteger(n);
		}
	}

	@Override
	public String toString() {
		return n.toString();
	}
}


class JSONObject extends JSONValue {
	private final MyList members;
	public JSONObject(MyList members) {
		if (members == null) throw new IllegalArgumentException();
		this.members = members;
	}

	@Override
	public String toString() {
		return "{ " + members.toString() + " }";
	}
}


class LexerError extends RuntimeException {
	private static final long serialVersionUID = -6554542041382870784L;
}

class ParseError extends RuntimeException {
	private static final long serialVersionUID = -2687440417554884854L;
}

abstract class MyList {}
class Singleton extends MyList {
	private final Pair p;
	public Singleton(Pair p) {
		this.p = p;
	}

	@Override
	public String toString() {
		return p.toString();
	}
}

class Cons extends MyList {
	private final Pair p;
	private final MyList l;

	public Cons(Pair p, MyList l) {
		this.p = p;
		this.l = l;
	}

	@Override
	public String toString() {
		return p.toString() + ", " + l.toString();
	}
}
