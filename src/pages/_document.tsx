import Document, { Head, Html, Main, NextScript } from "next/document";

class AppDocument extends Document {
	render() {
		return (
			<Html lang="en">
				<Head>
					{/* eslint-disable-next-line @next/next/no-sync-scripts */}
					<script src="/config.js"></script>
				</Head>
				<body>
					<Main />
					<NextScript />
				</body>
			</Html>
		);
	}
}

export default AppDocument;
