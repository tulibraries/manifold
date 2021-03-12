/******/ (function(modules) { // webpackBootstrap
/******/ 	// The module cache
/******/ 	var installedModules = {};
/******/
/******/ 	// The require function
/******/ 	function __webpack_require__(moduleId) {
/******/
/******/ 		// Check if module is in cache
/******/ 		if(installedModules[moduleId]) {
/******/ 			return installedModules[moduleId].exports;
/******/ 		}
/******/ 		// Create a new module (and put it into the cache)
/******/ 		var module = installedModules[moduleId] = {
/******/ 			i: moduleId,
/******/ 			l: false,
/******/ 			exports: {}
/******/ 		};
/******/
/******/ 		// Execute the module function
/******/ 		modules[moduleId].call(module.exports, module, module.exports, __webpack_require__);
/******/
/******/ 		// Flag the module as loaded
/******/ 		module.l = true;
/******/
/******/ 		// Return the exports of the module
/******/ 		return module.exports;
/******/ 	}
/******/
/******/
/******/ 	// expose the modules object (__webpack_modules__)
/******/ 	__webpack_require__.m = modules;
/******/
/******/ 	// expose the module cache
/******/ 	__webpack_require__.c = installedModules;
/******/
/******/ 	// define getter function for harmony exports
/******/ 	__webpack_require__.d = function(exports, name, getter) {
/******/ 		if(!__webpack_require__.o(exports, name)) {
/******/ 			Object.defineProperty(exports, name, { enumerable: true, get: getter });
/******/ 		}
/******/ 	};
/******/
/******/ 	// define __esModule on exports
/******/ 	__webpack_require__.r = function(exports) {
/******/ 		if(typeof Symbol !== 'undefined' && Symbol.toStringTag) {
/******/ 			Object.defineProperty(exports, Symbol.toStringTag, { value: 'Module' });
/******/ 		}
/******/ 		Object.defineProperty(exports, '__esModule', { value: true });
/******/ 	};
/******/
/******/ 	// create a fake namespace object
/******/ 	// mode & 1: value is a module id, require it
/******/ 	// mode & 2: merge all properties of value into the ns
/******/ 	// mode & 4: return value when already ns object
/******/ 	// mode & 8|1: behave like require
/******/ 	__webpack_require__.t = function(value, mode) {
/******/ 		if(mode & 1) value = __webpack_require__(value);
/******/ 		if(mode & 8) return value;
/******/ 		if((mode & 4) && typeof value === 'object' && value && value.__esModule) return value;
/******/ 		var ns = Object.create(null);
/******/ 		__webpack_require__.r(ns);
/******/ 		Object.defineProperty(ns, 'default', { enumerable: true, value: value });
/******/ 		if(mode & 2 && typeof value != 'string') for(var key in value) __webpack_require__.d(ns, key, function(key) { return value[key]; }.bind(null, key));
/******/ 		return ns;
/******/ 	};
/******/
/******/ 	// getDefaultExport function for compatibility with non-harmony modules
/******/ 	__webpack_require__.n = function(module) {
/******/ 		var getter = module && module.__esModule ?
/******/ 			function getDefault() { return module['default']; } :
/******/ 			function getModuleExports() { return module; };
/******/ 		__webpack_require__.d(getter, 'a', getter);
/******/ 		return getter;
/******/ 	};
/******/
/******/ 	// Object.prototype.hasOwnProperty.call
/******/ 	__webpack_require__.o = function(object, property) { return Object.prototype.hasOwnProperty.call(object, property); };
/******/
/******/ 	// __webpack_public_path__
/******/ 	__webpack_require__.p = "/packs/";
/******/
/******/
/******/ 	// Load entry module and return exports
/******/ 	return __webpack_require__(__webpack_require__.s = "./app/javascript/packs/application_BACKUP_5663.js");
/******/ })
/************************************************************************/
/******/ ({

/***/ "./app/javascript/packs/application_BACKUP_5663.js":
/*!*********************************************************!*\
  !*** ./app/javascript/packs/application_BACKUP_5663.js ***!
  \*********************************************************/
/*! no static exports found */
/***/ (function(module, exports) {

throw new Error("Module build failed (from ./node_modules/babel-loader/lib/index.js):\nSyntaxError: /Users/skng/Projects/lwr/manifold/app/javascript/packs/application_BACKUP_5663.js: Unexpected token (22:2)\n\n  20 | // const imagePath = (name) => images(name, true)\n  21 | \n> 22 | <<<<<<< HEAD\n     |   ^\n  23 | console.log('Hello World from Webpacker')\n  24 | =======\n  25 | require(\"@rails/actiontext\")\n    at Parser._raise (/Users/skng/Projects/lwr/manifold/node_modules/@babel/parser/lib/index.js:766:17)\n    at Parser.raiseWithData (/Users/skng/Projects/lwr/manifold/node_modules/@babel/parser/lib/index.js:759:17)\n    at Parser.raise (/Users/skng/Projects/lwr/manifold/node_modules/@babel/parser/lib/index.js:753:17)\n    at Parser.unexpected (/Users/skng/Projects/lwr/manifold/node_modules/@babel/parser/lib/index.js:8966:16)\n    at Parser.parseExprAtom (/Users/skng/Projects/lwr/manifold/node_modules/@babel/parser/lib/index.js:10282:20)\n    at Parser.parseExprSubscripts (/Users/skng/Projects/lwr/manifold/node_modules/@babel/parser/lib/index.js:9844:23)\n    at Parser.parseUpdate (/Users/skng/Projects/lwr/manifold/node_modules/@babel/parser/lib/index.js:9824:21)\n    at Parser.parseMaybeUnary (/Users/skng/Projects/lwr/manifold/node_modules/@babel/parser/lib/index.js:9813:17)\n    at Parser.parseExprOpBaseRightExpr (/Users/skng/Projects/lwr/manifold/node_modules/@babel/parser/lib/index.js:9774:34)\n    at Parser.parseExprOpRightExpr (/Users/skng/Projects/lwr/manifold/node_modules/@babel/parser/lib/index.js:9767:21)\n    at Parser.parseExprOp (/Users/skng/Projects/lwr/manifold/node_modules/@babel/parser/lib/index.js:9733:27)\n    at Parser.parseExprOps (/Users/skng/Projects/lwr/manifold/node_modules/@babel/parser/lib/index.js:9689:17)\n    at Parser.parseMaybeConditional (/Users/skng/Projects/lwr/manifold/node_modules/@babel/parser/lib/index.js:9657:23)\n    at Parser.parseMaybeAssign (/Users/skng/Projects/lwr/manifold/node_modules/@babel/parser/lib/index.js:9620:21)\n    at Parser.parseExpressionBase (/Users/skng/Projects/lwr/manifold/node_modules/@babel/parser/lib/index.js:9564:23)\n    at /Users/skng/Projects/lwr/manifold/node_modules/@babel/parser/lib/index.js:9558:39\n    at Parser.allowInAnd (/Users/skng/Projects/lwr/manifold/node_modules/@babel/parser/lib/index.js:11296:16)\n    at Parser.parseExpression (/Users/skng/Projects/lwr/manifold/node_modules/@babel/parser/lib/index.js:9558:17)\n    at Parser.parseStatementContent (/Users/skng/Projects/lwr/manifold/node_modules/@babel/parser/lib/index.js:11561:23)\n    at Parser.parseStatement (/Users/skng/Projects/lwr/manifold/node_modules/@babel/parser/lib/index.js:11430:17)\n    at Parser.parseBlockOrModuleBlockBody (/Users/skng/Projects/lwr/manifold/node_modules/@babel/parser/lib/index.js:12012:25)\n    at Parser.parseBlockBody (/Users/skng/Projects/lwr/manifold/node_modules/@babel/parser/lib/index.js:11998:10)\n    at Parser.parseTopLevel (/Users/skng/Projects/lwr/manifold/node_modules/@babel/parser/lib/index.js:11361:10)\n    at Parser.parse (/Users/skng/Projects/lwr/manifold/node_modules/@babel/parser/lib/index.js:13044:10)\n    at parse (/Users/skng/Projects/lwr/manifold/node_modules/@babel/parser/lib/index.js:13097:38)\n    at parser (/Users/skng/Projects/lwr/manifold/node_modules/@babel/core/lib/parser/index.js:54:34)\n    at parser.next (<anonymous>)\n    at normalizeFile (/Users/skng/Projects/lwr/manifold/node_modules/@babel/core/lib/transformation/normalize-file.js:99:38)\n    at normalizeFile.next (<anonymous>)\n    at run (/Users/skng/Projects/lwr/manifold/node_modules/@babel/core/lib/transformation/index.js:31:50)");

/***/ })

/******/ });
//# sourceMappingURL=application_BACKUP_5663-a54bc4eef76d09db74bc.js.map