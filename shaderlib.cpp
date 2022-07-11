typedef unsigned int uint32_t;

namespace bx
{
	struct WriterI;
}
namespace bgfx
{
struct Options;
bool compileShader(const char* _varying, const char* _comment, char* _shader, uint32_t _shaderLen, Options& _options, bx::WriterI* _writer);
int compileShader(int _argc, const char* _argv[]);
}

extern "C"
{
	int __declspec(dllexport) compileShaderCmd(int _argc, const char* _argv[])
	{
		return bgfx::compileShader(_argc, _argv);
	}

	bool __declspec(dllexport) 
		compileShader(const char* _varying, const char* _comment, char* _shader, uint32_t _shaderLen, bgfx::Options& _options, bx::WriterI* _writer)
	{
		return bgfx::compileShader(_varying, _comment, _shader, _shaderLen, _options, _writer);
	}
}
